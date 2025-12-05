package com.ShapeUp.boot.app.user.controller;

import java.util.HashMap;
import java.util.List;
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
import com.ShapeUp.boot.domain.user.model.vo.UserProfileImageVO;
import com.ShapeUp.boot.domain.user.model.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.web.multipart.MultipartFile;
import com.ShapeUp.boot.domain.user.model.service.RequestPermissionService;
import com.ShapeUp.boot.domain.user.model.vo.RequestPermissionVO;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;  // ⭐ 추가


@Slf4j
@Controller
@RequiredArgsConstructor
public class UserController {
    private final MailService mailService;
    private final UserService userService;
    private final BCryptPasswordEncoder passwordEncoder;
    private final RequestPermissionService requestPermissionService;
    
    // ⭐⭐⭐ 프로필 이미지 업로드 경로 설정
    private static final String PROFILE_UPLOAD_PATH = System.getProperty("user.dir") + "/uploads/profile/";
    private static final String PROFILE_CONTEXT_PATH = "/upload/profile";  // ⭐ /upload로 시작

    // 이메일 인증
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
        
        response.put("available", !isDuplicate);
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
        
        response.put("available", !isDuplicate);
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
        Boolean isSocialLogin = (Boolean) session.getAttribute("isSocialLogin");
        
        if (isSocialLogin != null && isSocialLogin) {
            model.addAttribute("isSocialLogin", true);
            model.addAttribute("socialName", session.getAttribute("socialName"));
            model.addAttribute("socialEmail", session.getAttribute("socialEmail"));
        } else {
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

        Boolean isSocialLogin = (Boolean) session.getAttribute("isSocialLogin");
        boolean socialLogin = (isSocialLogin != null && isSocialLogin);

        if (!socialLogin) {
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
            @RequestParam String genderDigit,
            HttpSession session,
            Model model) {
        
        try {
            log.info("✅ 소셜 로그인 추가 정보 업데이트 시작 - 닉네임: {}", nickname);
            
            UserVO loginUser = (UserVO) session.getAttribute("loginUser");
            
            if (loginUser == null) {
                log.error("❌ 세션에 loginUser가 없음");
                model.addAttribute("errorMsg", "로그인 정보가 없습니다.");
                return "redirect:/user/login";
            }
            
            log.info("✅ 세션 사용자 확인 - userNo: {}, userId: {}", loginUser.getUserNo(), loginUser.getUserId());
            
            if (!nickname.equals(loginUser.getUserNickname())) {
                int nicknameCount = userService.checkNicknameDuplicate(nickname);
                if (nicknameCount > 0) {
                    log.warn("❌ 닉네임 중복: {}", nickname);
                    model.addAttribute("errorMsg", "이미 사용 중인 닉네임입니다.");
                    return "redirect:/user/signupInsertInfo";
                }
            }
            
            String userSerialNo = birthDate + "-" + genderDigit;
            int birthYear = Integer.parseInt(birthDate.substring(0, 2));
            
            if (genderDigit.equals("1") || genderDigit.equals("2")) {
                birthYear += 1900;
            } else if (genderDigit.equals("3") || genderDigit.equals("4")) {
                birthYear += 2000;
            } else {
                birthYear += 2000;
            }
            
            int age = java.time.Year.now().getValue() - birthYear + 1;
            
            log.info("✅ 계산된 나이: {}, 주민번호: {}", age, userSerialNo);
            
            UserVO updateUser = new UserVO();
            updateUser.setUserNo(loginUser.getUserNo());
            updateUser.setUserName(name);
            updateUser.setUserNickname(nickname);
            updateUser.setUserAge(age);
            updateUser.setUserPhone(phone);
            updateUser.setUserSerialNo(userSerialNo);
            
            int result = userService.updateSocialUserInfo(updateUser);
            
            log.info("✅ DB 업데이트 결과: {}", result);
            
            if (result > 0) {
                log.info("✅ 소셜 로그인 사용자 정보 업데이트 성공");
                
                loginUser.setUserName(name);
                loginUser.setUserNickname(nickname);
                loginUser.setUserAge(age);
                loginUser.setUserPhone(phone);
                loginUser.setUserSerialNo(userSerialNo);
                
                session.setAttribute("loginUser", loginUser);
                session.setAttribute("userNickname", nickname);
                session.setAttribute("userId", loginUser.getUserId());
                session.setAttribute("email", loginUser.getUserEmail());
                session.setAttribute("name", name);
                session.setAttribute("nickname", nickname);
                session.setAttribute("phone", phone);
                session.setAttribute("userSerialNo", userSerialNo);
                session.setAttribute("age", age);
                
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

            UserVO existingUser = (UserVO) session.getAttribute("loginUser");
            Boolean isSocialLogin = (Boolean) session.getAttribute("isSocialLogin");
            
            if (existingUser != null && isSocialLogin != null && isSocialLogin) {
                int userNo = existingUser.getUserNo();
                
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

            if (userId == null || password == null || name == null || 
                nickname == null || email == null || phone == null || 
                userSerialNo == null || age == null) {
                log.error("❌ 세션 데이터 누락");
                return "redirect:/user/signupInsertInfo?error=session";
            }

            log.info("✅ 일반 회원 설문조사 완료 - DB INSERT 시작");

            String encodedPassword = passwordEncoder.encode(password);

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

            int result = userService.insertUser(user);

            if (result > 0) {
                log.info("✅ 일반 회원 정보 INSERT 성공");
                
                int userNo = userService.selectUserNoByUserId(userId);
                
                if (userNo > 0) {
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
            @RequestParam(required = false) String autoLogin,
            HttpSession session,
            HttpServletResponse response,
            Model model
    ) {
        UserVO user = userService.selectUserById(userId);

        if(user != null && passwordEncoder.matches(userPw, user.getUserPw())) {
            if ("정지".equals(user.getStatus())) {
                java.sql.Timestamp until = user.getUpdatedAt();
                java.time.Instant now = java.time.Instant.now();
                if (until == null || until.toInstant().isAfter(now)) {
                    model.addAttribute("errorMsg", "해당 계정은 정지 상태입니다. 해제 예정일: " +
                            (until != null ? until.toLocalDateTime().toLocalDate() : "미정"));
                    return "user/login";
                }
            }
            
            session.setAttribute("userNo", user.getUserNo());
            session.setAttribute("userNickname", user.getUserNickname());
            session.setAttribute("loginUser", user);
            session.setAttribute("userType", user.getUserType());
            session.setAttribute("loginUserEmail", user.getUserEmail());

            if ("on".equals(autoLogin)) {
                String encodedUserId = Base64.getEncoder()
                        .encodeToString(userId.getBytes());

                Cookie cookie = new Cookie("rememberId", encodedUserId);
                cookie.setMaxAge(60 * 60 * 24 * 30);
                cookie.setPath("/");
                cookie.setHttpOnly(true);

                response.addCookie(cookie);
                
                log.info("✅ 자동 로그인 쿠키 생성: {}", userId);
            }

            // 권한별 진입 페이지 분기 (환경 의존도를 줄이기 위해 상대 경로 사용)
            if ("SYSTEM_MANAGER".equalsIgnoreCase(user.getUserType())) {
                return "redirect:/admin";
            } else if ("STADIUM_MANAGER".equalsIgnoreCase(user.getUserType())) {
                return "redirect:/stadium";
            } else {
                return "redirect:/";
            }
        } else {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "user/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, HttpServletResponse response) {
        session.invalidate();

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

            UserVO user = userService.findUserByUserId(userId);

            if (user == null) {
                log.warn("❌ 사용자를 찾을 수 없음 - userId: {}", userId);
                response.put("success", false);
                response.put("message", "일치하는 회원 정보가 없습니다.");
                return response;
            }

            String tempPw = generateTempPassword();
            log.info("✅ 임시 비밀번호 생성 완료");

            String encodedPw = passwordEncoder.encode(tempPw);

            int result = userService.updateUserPassword(user.getUserId(), encodedPw);

            if (result > 0) {
                log.info(" DB 비밀번호 업데이트 성공");

                String userEmail = user.getUserEmail();
                boolean emailSent = mailService.sendTempPassword(userEmail, tempPw);

                if (emailSent) {
                    log.info("임시 비밀번호 이메일 발송 성공 - email: {}", maskEmail(userEmail));
                    response.put("success", true);
                    response.put("email", maskEmail(userEmail));
                    response.put("message", "임시 비밀번호를 이메일로 발송했습니다.");
                } else {
                    log.error("이메일 발송 실패");
                    response.put("success", false);
                    response.put("message", "이메일 발송에 실패했습니다. 잠시 후 다시 시도해주세요.");
                }
            } else {
                log.error("DB 비밀번호 업데이트 실패");
                response.put("success", false);
                response.put("message", "비밀번호 변경 중 오류가 발생했습니다.");
            }

        } catch (Exception e) {
            log.error("비밀번호 찾기 오류", e);
            response.put("success", false);
            response.put("message", "오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }

        return response;
    }

    private String generateTempPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder tempPw = new StringBuilder();
        java.util.Random random = new java.util.Random();
        
        for (int i = 0; i < 8; i++) {
            tempPw.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return tempPw.toString();
    }

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
     * 회원정보 수정 페이지 (⭐ 프로필 이미지 조회 추가)
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
        
        // ⭐⭐⭐ 프로필 이미지 조회 추가
        UserProfileImageVO profileImage = userService.getProfileImage(userNo);
        
        model.addAttribute("user", user);
        model.addAttribute("profileImage", profileImage);  // ⭐ 추가
        
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
            
            if (userService.isEmailExists(email)) {
                UserVO existingUser = userService.selectUserByEmail(email);
                if (existingUser.getUserNo() != userNo) {
                    response.put("success", false);
                    response.put("message", "이미 사용 중인 이메일입니다.");
                    return response;
                }
            }
            
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
            
            UserVO user = userService.selectUserByUserNo(userNo);
            
            if (user == null) {
                response.put("success", false);
                response.put("message", "사용자 정보를 찾을 수 없습니다.");
                return response;
            }
            
            if (!passwordEncoder.matches(currentPassword, user.getUserPw())) {
                response.put("success", false);
                response.put("message", "현재 비밀번호가 일치하지 않습니다.");
                return response;
            }
            
            String encodedNewPassword = passwordEncoder.encode(newPassword);
            
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
            
            UserVO user = userService.selectUserByUserNo(userNo);
            
            if (user == null) {
                response.put("success", false);
                response.put("message", "사용자 정보를 찾을 수 없습니다.");
                return response;
            }
            
            if (!passwordEncoder.matches(password, user.getUserPw())) {
                response.put("success", false);
                response.put("message", "비밀번호가 일치하지 않습니다.");
                return response;
            }
            
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
        
        UserVO user = userService.selectUserByUserNo(userNo);
        
        if (user == null) {
            session.invalidate();
            return "redirect:/user/login";
        }
        
        UserInterestVO userInterest = userService.selectUserInterest(userNo);
        
        model.addAttribute("user", user);
        model.addAttribute("userInterest", userInterest != null ? userInterest : new UserInterestVO());
        
        return "user/updateInterest";
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
            
            UserInterestVO existingInterest = userService.selectUserInterest(userNo);
            
            int result;
            if (existingInterest != null) {
                result = userService.updateUserInterest(userNo, interests, times);
            } else {
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
    
    /* ================================
        ⭐⭐⭐ 프로필 이미지 관련 메서드 (새로 추가)
    ================================ */
    
    /**
     * 프로필 이미지 업로드
     */
    @PostMapping("/user/uploadProfileImage")
    @ResponseBody
    public Map<String, Object> uploadProfileImage(
            @RequestParam("profileImage") MultipartFile profileImage,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userNo = (Integer) session.getAttribute("userNo");
            
            if (userNo == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }
            
            if (profileImage == null || profileImage.isEmpty()) {
                response.put("success", false);
                response.put("message", "업로드할 파일이 없습니다.");
                return response;
            }
            
            // 파일 크기 체크 (5MB)
            long fileSize = profileImage.getSize();
            if (fileSize > 5 * 1024 * 1024) {
                response.put("success", false);
                response.put("message", "파일 크기는 5MB를 초과할 수 없습니다.");
                return response;
            }
            
            // 파일 확장자 체크
            String originalFilename = profileImage.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
            
            if (!extension.equals(".jpg") && !extension.equals(".jpeg") && !extension.equals(".png")) {
                response.put("success", false);
                response.put("message", "JPG, PNG 파일만 업로드 가능합니다.");
                return response;
            }
            
            // 파일명 생성 (UUID + 타임스탬프)
            String timestamp = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
            String uuid = UUID.randomUUID().toString().substring(0, 8);
            String renamedFilename = "profile_" + userNo + "_" + timestamp + "_" + uuid + extension;
            
            // 업로드 디렉토리 생성
            File dir = new File(PROFILE_UPLOAD_PATH);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            
            // 파일 저장
            File destinationFile = new File(PROFILE_UPLOAD_PATH + renamedFilename);
            profileImage.transferTo(destinationFile);
            
            // DB에 저장할 이미지 정보 생성
            UserProfileImageVO profileImageDto = new UserProfileImageVO();
            profileImageDto.setUserNo(userNo);
            profileImageDto.setImgPath(PROFILE_CONTEXT_PATH);
            profileImageDto.setImgRename(renamedFilename);
            profileImageDto.setImgOriginalName(originalFilename);
            profileImageDto.setImgMain("Y");
            
            // 기존 프로필 이미지가 있다면 삭제
            UserProfileImageVO existingImage = userService.getProfileImage(userNo);
            if (existingImage != null) {
                // 기존 파일 삭제
                File oldFile = new File(PROFILE_UPLOAD_PATH + existingImage.getImgRename());
                if (oldFile.exists()) {
                    oldFile.delete();
                }
                // DB에서 기존 이미지 삭제
                userService.deleteProfileImage(userNo);
            }
            
            // 새 프로필 이미지 DB에 저장
            int result = userService.insertProfileImage(profileImageDto);
            
            if (result > 0) {
                log.info("✅ 프로필 이미지 업로드 성공 - userNo: {}, file: {}", userNo, renamedFilename);
                response.put("success", true);
                response.put("message", "프로필 이미지가 변경되었습니다.");
                response.put("imagePath", PROFILE_CONTEXT_PATH + renamedFilename);
            } else {
                // DB 저장 실패 시 업로드된 파일 삭제
                destinationFile.delete();
                response.put("success", false);
                response.put("message", "프로필 이미지 저장에 실패했습니다.");
            }
            
        } catch (IOException e) {
            log.error("❌ 파일 업로드 중 오류", e);
            response.put("success", false);
            response.put("message", "파일 업로드 중 오류가 발생했습니다.");
        } catch (Exception e) {
            log.error("❌ 프로필 이미지 변경 오류", e);
            response.put("success", false);
            response.put("message", "프로필 이미지 변경 중 오류가 발생했습니다.");
        }
        
        return response;
    }
    
    /**
     * 프로필 이미지 삭제
     */
    @PostMapping("/user/deleteProfileImage")
    @ResponseBody
    public Map<String, Object> deleteProfileImage(HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userNo = (Integer) session.getAttribute("userNo");
            
            if (userNo == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }
            
            // 기존 프로필 이미지 조회
            UserProfileImageVO existingImage = userService.getProfileImage(userNo);
            
            if (existingImage == null) {
                response.put("success", false);
                response.put("message", "삭제할 프로필 이미지가 없습니다.");
                return response;
            }
            
            // 실제 파일 삭제
            File file = new File(PROFILE_UPLOAD_PATH + existingImage.getImgRename());
            if (file.exists()) {
                file.delete();
            }
            
            // DB에서 이미지 정보 삭제
            int result = userService.deleteProfileImage(userNo);
            
            if (result > 0) {
                log.info("✅ 프로필 이미지 삭제 성공 - userNo: {}", userNo);
                response.put("success", true);
                response.put("message", "프로필 이미지가 삭제되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "프로필 이미지 삭제에 실패했습니다.");
            }
            
        } catch (Exception e) {
            log.error("❌ 프로필 이미지 삭제 오류", e);
            response.put("success", false);
            response.put("message", "프로필 이미지 삭제 중 오류가 발생했습니다.");
        }
        
        return response;
    }
    
    /* ================================
        권한 신청 관련
    ================================ */
	
	 /**
	  * 권한 신청 처리
	  */
    @PostMapping("/user/requestPermission")
    @ResponseBody
    public Map<String, Object> requestPermission(
            @RequestParam("requestType") String requestType,
            @RequestParam("requestReason") String requestReason,
            @RequestParam(value = "businessName", required = false) String businessName,
            @RequestParam(value = "businessNumber", required = false) String businessNumber,
            @RequestParam(value = "certificateType", required = false) String certificateType,
            @RequestParam(value = "certificateNumber", required = false) String certificateNumber,
            @RequestParam(value = "career", required = false) String career,                    // ⭐ 추가
            @RequestParam(value = "careerDetail", required = false) String careerDetail,        // ⭐ 추가
            @RequestParam("attachmentFile") MultipartFile attachmentFile,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Integer userNo = (Integer) session.getAttribute("userNo");
            
            if (userNo == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }
            
            RequestPermissionVO pendingRequest = requestPermissionService.getPendingRequestByUserNo(userNo);
            if (pendingRequest != null) {
                response.put("success", false);
                response.put("message", "이미 처리 대기 중인 신청이 있습니다.");
                return response;
            }
            
            String uploadPath = saveFile(attachmentFile);
            
            if (uploadPath == null) {
                response.put("success", false);
                response.put("message", "파일 업로드에 실패했습니다.");
                return response;
            }
            
            RequestPermissionVO request = new RequestPermissionVO();
            request.setUserNo(userNo);
            request.setRequestType(requestType);
            request.setRequestReason(requestReason);
            request.setBusinessName(businessName);
            request.setBusinessNumber(businessNumber);
            request.setCertificateType(certificateType);
            request.setCertificateNumber(certificateNumber);
            request.setCareer(career);                         // ⭐ 추가
            request.setCareerDetail(careerDetail);             // ⭐ 추가
            request.setAttachmentPath(uploadPath);
            request.setAttachmentOrigin(attachmentFile.getOriginalFilename());
            request.setAttachmentRename(new File(uploadPath).getName());
            
            int result = requestPermissionService.insertRequestPermission(request);
            
            if (result > 0) {
                log.info("✅ 권한 신청 완료 - userNo: {}, type: {}", userNo, requestType);
                response.put("success", true);
                response.put("message", "권한 신청이 완료되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "권한 신청에 실패했습니다.");
            }
            
        } catch (Exception e) {
            log.error("❌ 권한 신청 오류", e);
            response.put("success", false);
            response.put("message", "오류가 발생했습니다.");
        }
        
        return response;
    }
	
	 /**
	  * 파일 저장 메서드
	  */
	 private String saveFile(MultipartFile file) throws IOException {
	     if (file == null || file.isEmpty()) {
	         return null;
	     }
	     
	     String uploadDir = "C:/ShapeUp/uploads/permissions/";
	     
	     File dir = new File(uploadDir);
	     if (!dir.exists()) {
	         dir.mkdirs();
	     }
	     
	     String originalFilename = file.getOriginalFilename();
	     String extension = "";
	     if (originalFilename != null && originalFilename.contains(".")) {
	         extension = originalFilename.substring(originalFilename.lastIndexOf("."));
	     }
	     
	     SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss_SSS");
	     String timestamp = sdf.format(new Date());
	     String savedFilename = timestamp + extension;
	     
	     File destFile = new File(uploadDir + savedFilename);
	     file.transferTo(destFile);
	     
	     log.info("✅ 파일 저장 완료 - {}", destFile.getAbsolutePath());
	     
	     return destFile.getAbsolutePath();
	 }
	
	 /**
	  * 내 권한 신청 내역 조회
	  */
	 @GetMapping("/user/myRequests")
	 public String myRequests(HttpSession session, Model model) {
	     Integer userNo = (Integer) session.getAttribute("userNo");
	     
	     if (userNo == null) {
	         return "redirect:/user/login";
	     }
	     
	     List<RequestPermissionVO> requests = requestPermissionService.getRequestsByUserNo(userNo);
	     model.addAttribute("requests", requests);
	     
	     return "user/myRequests";
	 }
	
	 /**
	  * 권한 신청 취소
	  */
	 @PostMapping("/user/cancelRequest")
	 @ResponseBody
	 public Map<String, Object> cancelRequest(@RequestParam int requestNo, HttpSession session) {
	     Map<String, Object> response = new HashMap<>();
	     
	     try {
	         Integer userNo = (Integer) session.getAttribute("userNo");
	         
	         if (userNo == null) {
	             response.put("success", false);
	             response.put("message", "로그인이 필요합니다.");
	             return response;
	         }
	         
	         RequestPermissionVO request = requestPermissionService.getRequestByNo(requestNo);
	         
	         if (request == null || request.getUserNo() != userNo) {
	             response.put("success", false);
	             response.put("message", "권한이 없습니다.");
	             return response;
	         }
	         
	         if (!"대기".equals(request.getRequestStatus())) {
	             response.put("success", false);
	             response.put("message", "대기 중인 신청만 취소할 수 있습니다.");
	             return response;
	         }
	         
	         int result = requestPermissionService.cancelRequest(requestNo);
	         
	         if (result > 0) {
	             log.info("✅ 권한 신청 취소 - requestNo: {}", requestNo);
	             response.put("success", true);
	             response.put("message", "신청이 취소되었습니다.");
	         } else {
	             response.put("success", false);
	             response.put("message", "취소에 실패했습니다.");
	         }
	         
	     } catch (Exception e) {
	         log.error("❌ 신청 취소 오류", e);
	         response.put("success", false);
	         response.put("message", "오류가 발생했습니다.");
	     }
	     
	     return response;
	 }
	 
	 @PostMapping("/user/revokePermission")
	 @ResponseBody
	 public Map<String, Object> revokePermission(HttpSession session) {
	     Map<String, Object> response = new HashMap<>();
	     
	     try {
	         Integer userNo = (Integer) session.getAttribute("userNo");
	         
	         if (userNo == null) {
	             response.put("success", false);
	             response.put("message", "로그인이 필요합니다.");
	             return response;
	         }
	         
	         UserVO user = userService.selectUserByUserNo(userNo);
	         
	         if (user == null) {
	             response.put("success", false);
	             response.put("message", "사용자 정보를 찾을 수 없습니다.");
	             return response;
	         }
	         
	         if ("USER".equals(user.getUserType())) {
	             response.put("success", false);
	             response.put("message", "이미 일반 사용자입니다.");
	             return response;
	         }
	         
	         int result = userService.updateUserType(userNo, "USER");
	         
	         if (result > 0) {
	             log.info("✅ 권한 포기 완료 - userNo: {}, 기존 권한: {}", userNo, user.getUserType());
	             
	             session.setAttribute("userType", "USER");
	             
	             user.setUserType("USER");
	             session.setAttribute("loginUser", user);
	             
	             response.put("success", true);
	             response.put("message", "권한이 포기되었습니다. 일반 사용자로 전환되었습니다.");
	         } else {
	             response.put("success", false);
	             response.put("message", "권한 포기에 실패했습니다.");
	         }
	         
	     } catch (Exception e) {
	         log.error("❌ 권한 포기 오류", e);
	         response.put("success", false);
	         response.put("message", "오류가 발생했습니다.");
	     }
	     
	     return response;
	 }
	 
	 @GetMapping("/user/checkPendingRequest")
	 @ResponseBody
	 public Map<String, Object> checkPendingRequest(HttpSession session) {
	     Map<String, Object> response = new HashMap<>();
	     
	     try {
	         Integer userNo = (Integer) session.getAttribute("userNo");
	         
	         if (userNo == null) {
	             response.put("hasPending", false);
	             return response;
	         }
	         
	         RequestPermissionVO pendingRequest = requestPermissionService.selectPendingRequestByUserNo(userNo);
	         
	         if (pendingRequest != null) {
	             response.put("hasPending", true);
	             
	             Map<String, Object> requestInfo = new HashMap<>();
	             requestInfo.put("requestNo", pendingRequest.getRequestNo());
	             requestInfo.put("requestType", pendingRequest.getRequestType());
	             requestInfo.put("requestStatus", pendingRequest.getRequestStatus());
	             requestInfo.put("createdAt", pendingRequest.getCreatedAt());
	             
	             response.put("request", requestInfo);
	             log.info("✅ 대기 중인 신청 확인 - userNo: {}, requestType: {}", 
	                     userNo, pendingRequest.getRequestType());
	         } else {
	             response.put("hasPending", false);
	             log.info("ℹ️ 대기 중인 신청 없음 - userNo: {}", userNo);
	         }
	         
	     } catch (Exception e) {
	         log.error("❌ 대기 중인 신청 확인 오류", e);
	         response.put("hasPending", false);
	     }
	     
	     return response;
	 }
	 
	 @GetMapping("/user/checkRecentRequest")
	 @ResponseBody
	 public Map<String, Object> checkRecentRequest(HttpSession session) {
	     Map<String, Object> response = new HashMap<>();
	     
	     try {
	         Integer userNo = (Integer) session.getAttribute("userNo");
	         
	         if (userNo == null) {
	             response.put("hasRecent", false);
	             return response;
	         }
	         
	         List<RequestPermissionVO> requests = requestPermissionService.selectRequestsByUserNo(userNo);
	         
	         RequestPermissionVO recentRequest = null;
	         for (RequestPermissionVO request : requests) {
	             String status = request.getRequestStatus();
	             if ("승인".equals(status) || "반려".equals(status)) {
	                 String checkedKey = "checked_request_" + request.getRequestNo();
	                 Boolean isChecked = (Boolean) session.getAttribute(checkedKey);
	                 
	                 if (isChecked == null || !isChecked) {
	                     recentRequest = request;
	                     break;
	                 }
	             }
	         }
	         
	         if (recentRequest != null) {
	             response.put("hasRecent", true);
	             
	             Map<String, Object> requestInfo = new HashMap<>();
	             requestInfo.put("requestNo", recentRequest.getRequestNo());
	             requestInfo.put("requestType", recentRequest.getRequestType());
	             requestInfo.put("requestStatus", recentRequest.getRequestStatus());
	             requestInfo.put("processedAt", recentRequest.getProcessedAt());
	             requestInfo.put("rejectReason", recentRequest.getRejectReason());
	             
	             response.put("request", requestInfo);
	             
	             log.info("✅ 최근 처리된 신청 있음 - requestNo: {}, status: {}", 
	                     recentRequest.getRequestNo(), recentRequest.getRequestStatus());
	         } else {
	             response.put("hasRecent", false);
	             log.info("ℹ️ 최근 처리된 신청 없음 - userNo: {}", userNo);
	         }
	         
	     } catch (Exception e) {
	         log.error("❌ 최근 신청 확인 오류", e);
	         response.put("hasRecent", false);
	     }
	     
	     return response;
	 }

	 @PostMapping("/user/markNotificationRead")
	 @ResponseBody
	 public Map<String, Object> markNotificationRead(@RequestBody Map<String, Integer> payload, 
	                                                  HttpSession session) {
	     Map<String, Object> response = new HashMap<>();
	     
	     try {
	         Integer requestNo = payload.get("requestNo");
	         
	         if (requestNo != null) {
	             String checkedKey = "checked_request_" + requestNo;
	             session.setAttribute(checkedKey, true);
	             
	             log.info("✅ 알림 확인 처리 - requestNo: {}", requestNo);
	             response.put("success", true);
	         } else {
	             response.put("success", false);
	         }
	         
	     } catch (Exception e) {
	         log.error("❌ 알림 확인 처리 오류", e);
	         response.put("success", false);
	     }
	     
	     return response;
	 }
}
