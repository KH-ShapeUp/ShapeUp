package com.ShapeUp.boot.app.user.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.ShapeUp.boot.app.user.mail.MailService;
import com.ShapeUp.boot.domain.user.model.service.UserService;
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
    @PostMapping("/user/checkUserId")
    @ResponseBody
    public boolean checkUserId(@RequestParam String userid) {
        log.info("🔍 아이디 중복 체크 요청: {}", userid);
        int count = userService.checkUserIdDuplicate(userid);
        boolean result = count > 0;
        log.info("✅ 최종 반환값 (true=중복, false=사용가능): {}", result);
        return result;
    }

    @PostMapping("/user/checkNickname")
    @ResponseBody
    public boolean checkNickname(@RequestParam String nickname) {
        log.info("🔍 닉네임 중복 체크 요청: {}", nickname);
        int count = userService.checkNicknameDuplicate(nickname);
        boolean result = count > 0;
        log.info("✅ 최종 반환값 (true=중복, false=사용가능): {}", result);
        return result;
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
    public String signupInsertInfo() {
        return "user/signupInsertInfo";
    }

    @PostMapping("/user/signupInsertInfo")
    public String signupInsertInfoProcess(
            @RequestParam String userid,
            @RequestParam String password,
            @RequestParam String password2,
            @RequestParam String name,
            @RequestParam String nickname,
            @RequestParam String emailId,
            @RequestParam String emailDomain,
            @RequestParam String phone,
            @RequestParam String birthDate,
            @RequestParam String genderDigit,
            HttpSession session
    ) {
        log.info("회원가입 정보 입력 - 아이디: {}, 닉네임: {}", userid, nickname);

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

            if (userId == null || password == null || name == null || 
                nickname == null || email == null || phone == null || 
                userSerialNo == null || age == null) {
                log.error("세션 데이터 누락");
                return "redirect:/user/signupInsertInfo?error=session";
            }

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
                int userNo = userService.selectUserNoByUserId(userId);
                
                if (userNo > 0) {
                    if (interests != null || times != null || addresses != null) {
                        userService.insertUserInterest(
                            userNo, 
                            interests != null ? interests : "", 
                            times != null ? times : "", 
                            addresses != null ? addresses : ""
                        );
                    }
                    
                    session.invalidate();
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

    public String loginProcess(@RequestParam String userId,
                               @RequestParam String userPw,
                               HttpSession session,
                               Model model) {

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
    public String logout(HttpSession session) {
        session.invalidate();
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
    
 // UserController.java에 추가할 메서드들

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
}