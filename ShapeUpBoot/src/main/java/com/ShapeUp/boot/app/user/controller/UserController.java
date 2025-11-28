package com.ShapeUp.boot.app.user.controller;

import java.util.HashMap;
import java.util.Map;


import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Base64;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.ShapeUp.boot.app.user.mail.MailService;
import com.ShapeUp.boot.domain.user.model.service.UserService;
import com.ShapeUp.boot.domain.user.model.vo.UserInterestVO;
import com.ShapeUp.boot.domain.user.model.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class UserController {
    private final MailService mailService;
    private final UserService userService;
    private final BCryptPasswordEncoder passwordEncoder;

    /* ================================
        이메일 인증
    ================================ */
    @ResponseBody
    @PostMapping("/user/sendEmailCode")
    public Map<String, Object> sendEmailCode(@RequestParam String email, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        String code = mailService.generateCode();
        boolean sent = mailService.sendVerificationCode(email, code);

        if (sent) {
            mailService.storeCodeInSession(session, email, code, 5);
            response.put("success", true);
            response.put("message", "인증번호를 발송했습니다. 이메일을 확인하세요.");
        } else {
            response.put("success", false);
            response.put("message", "인증번호 발송 실패");
        }

        return response;
    }

    @ResponseBody
    @PostMapping("/user/verifyEmailCode")
    public Map<String, Object> verifyEmailCode(@RequestParam String email,
                                               @RequestParam String code,
                                               HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        boolean verified = mailService.verifyCode(session, email, code);

        if (verified) {
            response.put("success", true);
            response.put("message", "이메일 인증이 완료되었습니다.");
        } else {
            response.put("success", false);
            response.put("message", "인증번호가 일치하지 않거나 만료되었습니다.");
        }

        return response;
    }

    /* ================================
        중복 체크
    ================================ */
    @GetMapping("/user/checkNickname")
    @ResponseBody
    public Map<String, Object> checkNickname(@RequestParam String nickname) {
        log.info("🔍 닉네임 중복 체크 요청: {}", nickname);
        
        Map<String, Object> response = new HashMap<>();
        int count = userService.checkNicknameDuplicate(nickname);
        boolean isDuplicate = count > 0;
        
        response.put("available", !isDuplicate);  // true면 사용 가능
        response.put("message", isDuplicate ? "이미 사용 중인 닉네임입니다." : "사용 가능한 닉네임입니다.");
        
        log.info("✅ 닉네임 사용 가능 여부: {}", !isDuplicate);
        
        return response;
    }

    @GetMapping("/user/checkUserId")
    @ResponseBody
    public Map<String, Object> checkUserId(@RequestParam String userid) {
        log.info("🔍 아이디 중복 체크 요청: {}", userid);
        
        Map<String, Object> response = new HashMap<>();
        int count = userService.checkUserIdDuplicate(userid);
        boolean isDuplicate = count > 0;
        
        response.put("available", !isDuplicate);  // true면 사용 가능
        response.put("message", isDuplicate ? "이미 사용 중인 아이디입니다." : "사용 가능한 아이디입니다.");
        
        log.info("✅ 아이디 사용 가능 여부: {}", !isDuplicate);
        
        return response;
    }

    /* ================================
        회원가입 - 약관 동의
    ================================ */
    @GetMapping("/user/signupAgreement")
    public String signupAgreement() {
        return "user/signupAgreement";
    }

    @PostMapping("/user/signupAgreement")
    public String signupAgreementProcess(
            @RequestParam(required = false) String termsAgree,
            @RequestParam(required = false) String privacyAgree
    ) {
        if (termsAgree == null || privacyAgree == null) {
            return "redirect:/user/signupAgreement?error=required";
        }
        return "redirect:/user/signupInsertInfo";
    }

    /* ================================
        회원가입 - 정보 입력
    ================================ */
    @GetMapping("/user/signupInsertInfo")
    public String signupInsertInfo(HttpSession session, Model model) {
        // ✅ 소셜 로그인 여부 확인
        Boolean isSocialLogin = (Boolean) session.getAttribute("isSocialLogin");
        
        if (isSocialLogin != null && isSocialLogin) {
            // 소셜 로그인 정보를 모델에 추가
            model.addAttribute("isSocialLogin", true);
            model.addAttribute("socialName", session.getAttribute("socialName"));
            model.addAttribute("socialEmail", session.getAttribute("socialEmail"));
        } else {
            // 일반 회원가입
            model.addAttribute("isSocialLogin", false);
        }
        
        return "user/signupInsertInfo";
    }

    @PostMapping("/user/signupInsertInfo")
    public String signupInsertInfoProcess(
            @RequestParam(required = false) String userid,
            @RequestParam(required = false) String password,
            @RequestParam(required = false) String password2,
            @RequestParam String name,
            @RequestParam String nickname,
            @RequestParam String emailId,
            @RequestParam String emailDomain,
            @RequestParam String phone,
            @RequestParam String birthDate,
            @RequestParam String genderDigit,
            HttpSession session
    ) {
        log.info("회원가입 정보 입력 - 닉네임: {}", nickname);

        // ✅ 소셜 로그인 여부 확인
        Boolean isSocialLogin = (Boolean) session.getAttribute("isSocialLogin");
        boolean socialLogin = (isSocialLogin != null && isSocialLogin);

        if (!socialLogin) {
            // 일반 회원 검증
            if (!password.equals(password2)) {
                return "redirect:/user/signupInsertInfo?error=password";
            }

            Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
            if (emailVerified == null || !emailVerified) {
                return "redirect:/user/signupInsertInfo?error=emailNotVerified";
            }

            int userIdCount = userService.checkUserIdDuplicate(userid);
            if (userIdCount > 0) {
                return "redirect:/user/signupInsertInfo?error=duplicateId";
            }
        }

        int nicknameCount = userService.checkNicknameDuplicate(nickname);
        if (nicknameCount > 0) {
            return "redirect:/user/signupInsertInfo?error=duplicateNickname";
        }

        try {
            String email = emailId + "@" + emailDomain;
            String userSerialNo = birthDate + "-" + genderDigit;
            int birthYear = Integer.parseInt(birthDate.substring(0, 2));

            if (genderDigit.equals("1") || genderDigit.equals("2")) {
                birthYear += 1900;
            } else {
                birthYear += 2000;
            }

            int age = java.time.Year.now().getValue() - birthYear + 1;

            session.setAttribute("email", email);
            session.setAttribute("userId", userid);
            session.setAttribute("password", password);
            session.setAttribute("name", name);
            session.setAttribute("nickname", nickname);
            session.setAttribute("phone", phone);
            session.setAttribute("userSerialNo", userSerialNo);
            session.setAttribute("age", age);

            return "redirect:/user/signupSurvey";

        } catch (Exception e) {
            log.error("회원가입 정보 입력 중 오류 발생", e);
            return "redirect:/user/signupInsertInfo?error=exception";
        }
    }
    
    @PostMapping("/user/updateSocialUserInfo")
    public String updateSocialUserInfo(
            @RequestParam String name,
            @RequestParam String nickname,
            @RequestParam String birthDate,
            @RequestParam String phone,
            @RequestParam String genderDigit,  // ✅ 주민등록번호 뒷자리 첫 번째 숫자 (1~4)
            HttpSession session,
            Model model) {
        
        try {
            log.info("✅ 소셜 로그인 추가 정보 업데이트 시작 - 닉네임: {}", nickname);
            
            // 세션에서 사용자 정보 가져오기
            UserVO loginUser = (UserVO) session.getAttribute("loginUser");
            
            if (loginUser == null) {
                log.error("❌ 세션에 loginUser가 없음");
                model.addAttribute("errorMsg", "로그인 정보가 없습니다.");
                return "redirect:/user/login";
            }
            
            log.info("✅ 세션 사용자 확인 - userNo: {}, userId: {}", loginUser.getUserNo(), loginUser.getUserId());
            
            // 닉네임 중복 체크 (본인 제외)
            if (!nickname.equals(loginUser.getUserNickname())) {
                int nicknameCount = userService.checkNicknameDuplicate(nickname);
                if (nicknameCount > 0) {
                    log.warn("❌ 닉네임 중복: {}", nickname);
                    model.addAttribute("errorMsg", "이미 사용 중인 닉네임입니다.");
                    return "redirect:/user/signupInsertInfo";
                }
            }
            
            // 생년월일 처리 (YYMMDD-G 형식으로 저장)
            String userSerialNo = birthDate + "-" + genderDigit;
            int birthYear = Integer.parseInt(birthDate.substring(0, 2));
            
            // 주민등록번호 뒷자리로 1900년대생/2000년대생 구분
            if (genderDigit.equals("1") || genderDigit.equals("2")) {
                birthYear += 1900;
            } else if (genderDigit.equals("3") || genderDigit.equals("4")) {
                birthYear += 2000;
            } else {
                birthYear += 2000; // 기본값
            }
            
            int age = java.time.Year.now().getValue() - birthYear + 1;
            
            log.info("✅ 계산된 나이: {}, 주민번호: {}", age, userSerialNo);
            
            // 사용자 정보 업데이트
            UserVO updateUser = new UserVO();
            updateUser.setUserNo(loginUser.getUserNo());
            updateUser.setUserName(name);
            updateUser.setUserNickname(nickname);
            updateUser.setUserAge(age);
            updateUser.setUserPhone(phone);
            updateUser.setUserSerialNo(userSerialNo);
            
            // DB 업데이트
            int result = userService.updateSocialUserInfo(updateUser);
            
            log.info("✅ DB 업데이트 결과: {}", result);
            
            if (result > 0) {
                log.info("✅ 소셜 로그인 사용자 정보 업데이트 성공");
                
                // 세션의 loginUser 업데이트
                loginUser.setUserName(name);
                loginUser.setUserNickname(nickname);
                loginUser.setUserAge(age);
                loginUser.setUserPhone(phone);
                loginUser.setUserSerialNo(userSerialNo);
                
                session.setAttribute("loginUser", loginUser);
                session.setAttribute("userNickname", nickname);
                
                // ✅ 설문조사 페이지를 위한 세션 설정
                session.setAttribute("userId", loginUser.getUserId());
                session.setAttribute("email", loginUser.getUserEmail());
                session.setAttribute("name", name);
                session.setAttribute("nickname", nickname);
                session.setAttribute("phone", phone);
                session.setAttribute("userSerialNo", userSerialNo);
                session.setAttribute("age", age);
                
                // 소셜 로그인 플래그는 유지 (설문 페이지에서 구분 필요)
                // session.removeAttribute("isSocialLogin"); // 제거하지 않음
                session.removeAttribute("socialName");
                session.removeAttribute("socialEmail");
                
                log.info("✅ 설문조사 페이지로 리다이렉트");
                return "redirect:/user/signupSurvey";
            } else {
                log.error("❌ DB 업데이트 실패");
                model.addAttribute("errorMsg", "정보 업데이트에 실패했습니다.");
                return "redirect:/user/signupInsertInfo";
            }
            
        } catch (Exception e) {
            log.error("❌ 소셜 로그인 정보 업데이트 중 오류 발생", e);
            e.printStackTrace();
            model.addAttribute("errorMsg", "정보 업데이트 중 오류가 발생했습니다.");
            return "redirect:/user/signupInsertInfo";
        }
    }
    /* ================================
        회원가입 - 설문조사
    ================================ */
    @GetMapping("/user/signupSurvey")
    public String showSignupSurvey() {
        return "user/signupSurvey";
    }

    @GetMapping("/user/signupSuccess")
    public String signupSuccess() {
        return "user/signupSuccess";
    }

    @PostMapping("/user/signupSurvey")
    public String signupSurveyProcess(
            @RequestParam(required = false) String interests,
            @RequestParam(required = false) String times,
            @RequestParam(required = false) String addresses,
            HttpSession session
    ) {
        try {
            String userId = (String) session.getAttribute("userId");
            String password = (String) session.getAttribute("password");
            String name = (String) session.getAttribute("name");
            String nickname = (String) session.getAttribute("nickname");
            String email = (String) session.getAttribute("email");
            String phone = (String) session.getAttribute("phone");
            String userSerialNo = (String) session.getAttribute("userSerialNo");
            Integer age = (Integer) session.getAttribute("age");

            // ✅ 소셜 로그인 사용자는 이미 DB에 있으므로 관심사만 업데이트
            UserVO existingUser = (UserVO) session.getAttribute("loginUser");
            Boolean isSocialLogin = (Boolean) session.getAttribute("isSocialLogin");
            
            if (existingUser != null && isSocialLogin != null && isSocialLogin) {
                // 소셜 로그인 사용자 - 관심사만 추가
                int userNo = existingUser.getUserNo();
                
                // ✅ 관심사가 모두 입력된 경우만 INSERT
                if (interests != null && !interests.isBlank() && 
                    times != null && !times.isBlank() && 
                    addresses != null && !addresses.isBlank()) {
                    userService.insertUserInterest(
                        userNo, 
                        interests, 
                        times, 
                        addresses
                    );
                    log.info("✅ 소셜 로그인 사용자 관심사 등록 완료");
                } else {
                    log.info("⚠️ 소셜 로그인 사용자가 관심사를 입력하지 않음 - 스킵");
                }
                
                // 세션 정리
                session.removeAttribute("email");
                session.removeAttribute("userId");
                session.removeAttribute("name");
                session.removeAttribute("nickname");
                session.removeAttribute("phone");
                session.removeAttribute("userSerialNo");
                session.removeAttribute("age");
                session.removeAttribute("isSocialLogin");
                
                log.info("✅ 소셜 로그인 회원가입 완료");
                return "redirect:/user/signupSuccess";
            }

            // ✅ 일반 회원가입 - 설문조사 완료 후 DB INSERT
            if (userId == null || password == null || name == null || 
                nickname == null || email == null || phone == null || 
                userSerialNo == null || age == null) {
                log.error("❌ 세션 데이터 누락");
                return "redirect:/user/signupInsertInfo?error=session";
            }

            log.info("✅ 일반 회원 설문조사 완료 - DB INSERT 시작");

            // 비밀번호 암호화
            String encodedPassword = passwordEncoder.encode(password);

            // UserVO 생성
            UserVO user = new UserVO();
            user.setUserId(userId);
            user.setUserPw(encodedPassword);
            user.setUserName(name);
            user.setUserAge(age);
            user.setUserEmail(email);
            user.setUserPhone(phone);
            user.setUserSerialNo(userSerialNo);
            user.setUserNickname(nickname);
            user.setUserType("USER");
            user.setStatus("정상");

            // ✅ 회원 정보 INSERT
            int result = userService.insertUser(user);

            if (result > 0) {
                log.info("✅ 일반 회원 정보 INSERT 성공");
                
                int userNo = userService.selectUserNoByUserId(userId);
                
                if (userNo > 0) {
                    // ✅ 관심사가 모두 입력된 경우만 INSERT (선택 사항)
                    if (interests != null && !interests.isBlank() && 
                        times != null && !times.isBlank() && 
                        addresses != null && !addresses.isBlank()) {
                        userService.insertUserInterest(
                            userNo, 
                            interests, 
                            times, 
                            addresses
                        );
                        log.info("✅ 일반 회원 관심사 등록 완료");
                    } else {
                        log.info("⚠️ 일반 회원이 관심사를 입력하지 않음 - 스킵");
                    }
                    
                    // 세션 무효화
                    session.invalidate();
                    
                    log.info("✅ 일반 회원가입 완료");
                    return "redirect:/user/signupSuccess";
                } else {
                    log.error("❌ USER_NO 조회 실패");
                    return "redirect:/user/signupSurvey?error=fail";
                }
            } else {
                log.error("❌ 회원 INSERT 실패");
                return "redirect:/user/signupSurvey?error=fail";
            }

        } catch (Exception e) {
            log.error("❌ 회원가입 처리 중 오류 발생", e);
            e.printStackTrace();
            return "redirect:/user/signupSurvey?error=exception";
        }
    }

    /* ================================
        로그인
    ================================ */
    @GetMapping("/user/login")
    public String loginForm() {
        return "user/login";
    }

    @PostMapping("/user/login")
    public String loginProcess(
            @RequestParam String userId,
            @RequestParam String userPw,
            @RequestParam(required = false) String autoLogin,  // ⭐ 추가
            HttpSession session,
            HttpServletResponse response,  // ⭐ 추가
            Model model
    ) {
        UserVO user = userService.selectUserById(userId);

        if(user != null && passwordEncoder.matches(userPw, user.getUserPw())) {
            // 계정 정지 상태 체크
            if ("정지".equals(user.getStatus())) {
                java.sql.Timestamp until = user.getUpdatedAt();
                java.time.Instant now = java.time.Instant.now();
                if (until == null || until.toInstant().isAfter(now)) {
                    model.addAttribute("errorMsg", "해당 계정은 정지 상태입니다. 해제 예정일: " +
                            (until != null ? until.toLocalDateTime().toLocalDate() : "미정"));
                    return "user/login";
                }
            }
            
            // 세션에 사용자 정보 저장
            session.setAttribute("userNo", user.getUserNo());
            session.setAttribute("userNickname", user.getUserNickname());
            session.setAttribute("loginUser", user);
            session.setAttribute("userType", user.getUserType());
            session.setAttribute("loginUserEmail", user.getUserEmail());

            // ⭐⭐⭐ 자동 로그인 처리 (여기부터 추가)
            if ("on".equals(autoLogin)) {
                // userId를 Base64로 인코딩
                String encodedUserId = Base64.getEncoder()
                        .encodeToString(userId.getBytes());

                // 쿠키 생성 (30일 유지)
                Cookie cookie = new Cookie("rememberId", encodedUserId);
                cookie.setMaxAge(60 * 60 * 24 * 30); // 30일
                cookie.setPath("/");
                cookie.setHttpOnly(true); // JavaScript 접근 차단
                // cookie.setSecure(true); // HTTPS 환경에서만 사용

                response.addCookie(cookie);
                
                log.info("✅ 자동 로그인 쿠키 생성: {}", userId);
            }
            // ⭐⭐⭐ 여기까지 추가

            // 사용자 타입에 따른 리다이렉트
            if ("SYSTEM_MANAGER".equalsIgnoreCase(user.getUserType())) {
                return "redirect:http://localhost:5173/admin";
            } else if ("STADIUM_MANAGER".equalsIgnoreCase(user.getUserType())) {
                return "redirect:http://localhost:5173/stadium";
            } else {
                return "redirect:/";
            }
        } else {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "user/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, HttpServletResponse response) {  // ⭐ response 추가
        // 세션 무효화
        session.invalidate();

        // ⭐⭐⭐ 자동 로그인 쿠키 삭제 (여기 추가)
        Cookie cookie = new Cookie("rememberId", null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);

        log.info("✅ 로그아웃 완료 (자동 로그인 쿠키 삭제)");
        return "redirect:/";
    }

    /* ================================
        아이디 찾기
    ================================ */
    @GetMapping("/user/searchId")
    public String searchIdForm() {
        return "user/searchId";
    }

    @PostMapping("/user/searchId")
    @ResponseBody
    public Map<String, Object> searchId(
            @RequestParam String name,
            @RequestParam String emailId,
            @RequestParam String emailDomain,
            @RequestParam String phone) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            String email = emailId + "@" + emailDomain;
            UserVO user = userService.findUserByNameEmailPhone(name, email, phone);
            
            if (user != null) {
                String maskedId = maskUserId(user.getUserId());
                response.put("success", true);
                response.put("userId", maskedId);
                response.put("enrollDate", user.getCreatedAt());
            } else {
                response.put("success", false);
                response.put("message", "일치하는 회원 정보가 없습니다.");
            }
        } catch (Exception e) {
            log.error("아이디 찾기 오류", e);
            response.put("success", false);
            response.put("message", "오류가 발생했습니다.");
        }
        
        return response;
    }

    private String maskUserId(String userId) {
        if (userId == null || userId.length() <= 3) {
            return userId;
        }
        String visible = userId.substring(0, 3);
        String masked = "*".repeat(userId.length() - 3);
        return visible + masked;
    }

    /* ================================
        비밀번호 찾기 🔥 수정됨
    ================================ */
    @GetMapping("/user/searchPw")
    public String searchPwForm() {
        return "user/searchPw";
    }

    @ResponseBody
    @PostMapping("/user/searchPw")
    public Map<String, Object> searchPw(@RequestParam String userId) {
        Map<String, Object> response = new HashMap<>();

        try {
            log.info("🔍 비밀번호 찾기 요청 - userId: {}", userId);

            // 1) 아이디로 사용자 조회
            UserVO user = userService.findUserByUserId(userId);

            if (user == null) {
                log.warn("❌ 사용자를 찾을 수 없음 - userId: {}", userId);
                response.put("success", false);
                response.put("message", "일치하는 회원 정보가 없습니다.");
                return response;
            }

            // 2) 임시 비밀번호 생성 (8자리 영문+숫자)
            String tempPw = generateTempPassword();
            log.info("✅ 임시 비밀번호 생성 완료");

            // 3) 임시 비밀번호 암호화
            String encodedPw = passwordEncoder.encode(tempPw);

            // 4) DB 업데이트
            int result = userService.updateUserPassword(user.getUserId(), encodedPw);

            if (result > 0) {
                log.info("✅ DB 비밀번호 업데이트 성공");

                // 5) 이메일 발송
                String userEmail = user.getUserEmail();
                boolean emailSent = mailService.sendTempPassword(userEmail, tempPw);

                if (emailSent) {
                    log.info("✅ 임시 비밀번호 이메일 발송 성공 - email: {}", maskEmail(userEmail));
                    response.put("success", true);
                    response.put("email", maskEmail(userEmail));
                    response.put("message", "임시 비밀번호를 이메일로 발송했습니다.");
                } else {
                    log.error("❌ 이메일 발송 실패");
                    response.put("success", false);
                    response.put("message", "이메일 발송에 실패했습니다. 잠시 후 다시 시도해주세요.");
                }
            } else {
                log.error("❌ DB 비밀번호 업데이트 실패");
                response.put("success", false);
                response.put("message", "비밀번호 변경 중 오류가 발생했습니다.");
            }

        } catch (Exception e) {
            log.error("❌ 비밀번호 찾기 오류", e);
            response.put("success", false);
            response.put("message", "오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }

        return response;
    }

    /**
     * 임시 비밀번호 생성 (8자리 영문+숫자 조합)
     */
    private String generateTempPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder tempPw = new StringBuilder();
        java.util.Random random = new java.util.Random();
        
        for (int i = 0; i < 8; i++) {
            tempPw.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return tempPw.toString();
    }

    /**
     * 이메일 마스킹 처리 (abc***@example.com)
     */
    private String maskEmail(String email) {
        if (email == null || !email.contains("@")) {
            return email;
        }
        
        String[] parts = email.split("@");
        String localPart = parts[0];
        String domain = parts[1];
        
        if (localPart.length() <= 3) {
            return localPart.charAt(0) + "***@" + domain;
        }
        
        String visible = localPart.substring(0, 3);
        return visible + "***@" + domain;
    }
    
    /* ================================
        마이페이지
    ================================ */
    
    /**
     * 회원정보 수정 페이지
     */
    @GetMapping("/user/updateUserInfo")
    public String updateUserInfo(HttpSession session, Model model) {
        Integer userNo = (Integer) session.getAttribute("userNo");
        
        if (userNo == null) {
            return "redirect:/user/login";
        }
        
        // 사용자 정보 조회
        UserVO user = userService.selectUserByUserNo(userNo);
        
        if (user == null) {
            session.invalidate();
            return "redirect:/user/login";
        }
        
        model.addAttribute("user", user);
        return "user/updateUserInfo";
    }

    /**
     * 계정 관리 페이지 (회원 탈퇴)
     */
    @GetMapping("/user/accountManage")
    public String accountManage(HttpSession session, Model model) {
        Integer userNo = (Integer) session.getAttribute("userNo");
        
        if (userNo == null) {
            return "redirect:/user/login";
        }
        
        // 사용자 정보 조회
        UserVO user = userService.selectUserByUserNo(userNo);
        
        if (user == null) {
            session.invalidate();
            return "redirect:/user/login";
        }
        
        model.addAttribute("user", user);
        return "user/accountManage";
    }

    /**
     * 닉네임 변경
     */
    @PostMapping("/user/updateNickname")
    @ResponseBody
    public Map<String, Object> updateNickname(
            @RequestParam("userNo") int userNo,
            @RequestParam("nickname") String nickname) {

        log.info("닉네임 수정 요청: userNo={}, nickname={}", userNo, nickname);

        int result = userService.updateNickname(userNo, nickname);

        Map<String, Object> response = new HashMap<>();
        response.put("success", result > 0);
        response.put("message", result > 0 ? "닉네임 변경 성공" : "닉네임 변경 실패");

        return response;
    }

    /**
     * 이메일 변경
     */
    @PostMapping("/user/updateEmail")
    @ResponseBody
    public Map<String, Object> updateEmail(@RequestParam String email, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userNo = (Integer) session.getAttribute("userNo");
            
            if (userNo == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }
            
            // 이메일 중복 체크
            if (userService.isEmailExists(email)) {
                UserVO existingUser = userService.selectUserByEmail(email);
                // 본인의 이메일이 아닌 경우
                if (existingUser.getUserNo() != userNo) {
                    response.put("success", false);
                    response.put("message", "이미 사용 중인 이메일입니다.");
                    return response;
                }
            }
            
            // 이메일 업데이트
            int result = userService.updateUserEmail(userNo, email);
            
            if (result > 0) {
                log.info("✅ 이메일 변경 성공 - userNo: {}, email: {}", userNo, email);
                response.put("success", true);
                response.put("message", "이메일이 변경되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "이메일 변경에 실패했습니다.");
            }
            
        } catch (Exception e) {
            log.error("❌ 이메일 변경 오류", e);
            response.put("success", false);
            response.put("message", "오류가 발생했습니다.");
        }
        
        return response;
    }

    /**
     * 전화번호 변경
     */
    @PostMapping("/user/updatePhone")
    @ResponseBody
    public Map<String, Object> updatePhone(@RequestParam String phone, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userNo = (Integer) session.getAttribute("userNo");
            
            if (userNo == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }
            
            // 전화번호 업데이트
            int result = userService.updateUserPhone(userNo, phone);
            
            if (result > 0) {
                log.info("✅ 전화번호 변경 성공 - userNo: {}, phone: {}", userNo, phone);
                response.put("success", true);
                response.put("message", "전화번호가 변경되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "전화번호 변경에 실패했습니다.");
            }
            
        } catch (Exception e) {
            log.error("❌ 전화번호 변경 오류", e);
            response.put("success", false);
            response.put("message", "오류가 발생했습니다.");
        }
        
        return response;
    }

    /**
     * 비밀번호 변경
     */
    @PostMapping("/user/updatePassword")
    @ResponseBody
    public Map<String, Object> updatePassword(
            @RequestParam String currentPassword,
            @RequestParam String newPassword,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userNo = (Integer) session.getAttribute("userNo");
            
            if (userNo == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }
            
            // 현재 사용자 정보 조회
            UserVO user = userService.selectUserByUserNo(userNo);
            
            if (user == null) {
                response.put("success", false);
                response.put("message", "사용자 정보를 찾을 수 없습니다.");
                return response;
            }
            
            // 현재 비밀번호 확인
            if (!passwordEncoder.matches(currentPassword, user.getUserPw())) {
                response.put("success", false);
                response.put("message", "현재 비밀번호가 일치하지 않습니다.");
                return response;
            }
            
            // 새 비밀번호 암호화
            String encodedNewPassword = passwordEncoder.encode(newPassword);
            
            // 비밀번호 업데이트
            int result = userService.updateUserPasswordByUserNo(userNo, encodedNewPassword);
            
            if (result > 0) {
                log.info("✅ 비밀번호 변경 성공 - userNo: {}", userNo);
                response.put("success", true);
                response.put("message", "비밀번호가 변경되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "비밀번호 변경에 실패했습니다.");
            }
            
        } catch (Exception e) {
            log.error("❌ 비밀번호 변경 오류", e);
            response.put("success", false);
            response.put("message", "오류가 발생했습니다.");
        }
        
        return response;
    }

    /**
     * 회원 탈퇴
     */
    @PostMapping("/user/deleteAccount")
    @ResponseBody
    public Map<String, Object> deleteAccount(@RequestParam String password, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userNo = (Integer) session.getAttribute("userNo");
            
            if (userNo == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }
            
            // 현재 사용자 정보 조회
            UserVO user = userService.selectUserByUserNo(userNo);
            
            if (user == null) {
                response.put("success", false);
                response.put("message", "사용자 정보를 찾을 수 없습니다.");
                return response;
            }
            
            // 비밀번호 확인
            if (!passwordEncoder.matches(password, user.getUserPw())) {
                response.put("success", false);
                response.put("message", "비밀번호가 일치하지 않습니다.");
                return response;
            }
            
            // 회원 탈퇴 처리 (상태를 '탈퇴'로 변경)
            int result = userService.deleteUser(userNo);
            
            if (result > 0) {
                log.info("✅ 회원 탈퇴 성공 - userNo: {}", userNo);
                session.invalidate();
                response.put("success", true);
                response.put("message", "회원 탈퇴가 완료되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "회원 탈퇴에 실패했습니다.");
            }
            
        } catch (Exception e) {
            log.error("❌ 회원 탈퇴 오류", e);
            response.put("success", false);
            response.put("message", "오류가 발생했습니다.");
        }
        
        return response;
    }
    
    @GetMapping("/user/userInterest")
    public String userInterest(HttpSession session, Model model) {
        Integer userNo = (Integer) session.getAttribute("userNo");
        
        if (userNo == null) {
            return "redirect:/user/login";
        }
        
        // 사용자 정보 조회
        UserVO user = userService.selectUserByUserNo(userNo);
        
        if (user == null) {
            session.invalidate();
            return "redirect:/user/login";
        }
        
        // 기존 관심사 조회
        UserInterestVO userInterest = userService.selectUserInterest(userNo);
        
        model.addAttribute("user", user);
        model.addAttribute("userInterest", userInterest != null ? userInterest : new UserInterestVO());
        
        return "user/updateInterest";  // ⭐ 여기 수정!
    }

    /**
     * 관심사 업데이트
     */
    @PostMapping("/user/updateInterest")
    @ResponseBody
    public Map<String, Object> updateInterest(
            @RequestParam String interests,
            @RequestParam String times,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userNo = (Integer) session.getAttribute("userNo");
            
            if (userNo == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }
            
            // 기존 관심사 확인
            UserInterestVO existingInterest = userService.selectUserInterest(userNo);
            
            int result;
            if (existingInterest != null) {
                // 업데이트
                result = userService.updateUserInterest(userNo, interests, times);
            } else {
                // 새로 등록
                result = userService.insertUserInterest(userNo, interests, times, "");
            }
            
            if (result > 0) {
                log.info("✅ 관심사 저장 성공 - userNo: {}", userNo);
                response.put("success", true);
                response.put("message", "관심사가 저장되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "관심사 저장에 실패했습니다.");
            }
            
        } catch (Exception e) {
            log.error("❌ 관심사 저장 오류", e);
            response.put("success", false);
            response.put("message", "오류가 발생했습니다.");
        }
        
        return response;
    }
}