package com.ShapeUp.boot.app.user.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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
        0. 중복 체크 API
    ================================ */
    
    
    /* ================================
    이메일 인증 (InsertInfo 단계)
================================ */
    @ResponseBody
    @PostMapping("/user/sendEmailCode")
    public Map<String, Object> sendEmailCode(@RequestParam String email, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        String code = mailService.generateCode();
        boolean sent = mailService.sendVerificationCode(email, code);

        if (sent) {
            mailService.storeCodeInSession(session, email, code, 5); // 5분 유효
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

    
    /**
     * 아이디 중복 체크
     * @param userid 확인할 아이디
     * @return true: 중복(사용불가), false: 사용가능
     */
    @PostMapping("/user/checkUserId")
    @ResponseBody
    public boolean checkUserId(@RequestParam String userid) {
        log.info("🔍 아이디 중복 체크 요청: {}", userid);
        int count = userService.checkUserIdDuplicate(userid);
        log.info("📊 DB 조회 결과 count: {}", count);
        boolean result = count > 0;
        log.info("✅ 최종 반환값 (true=중복, false=사용가능): {}", result);
        return result;
    }

    /**
     * 닉네임 중복 체크
     * @param nickname 확인할 닉네임
     * @return true: 중복(사용불가), false: 사용가능
     */
    @PostMapping("/user/checkNickname")
    @ResponseBody
    public boolean checkNickname(@RequestParam String nickname) {
        log.info("🔍 닉네임 중복 체크 요청: {}", nickname);
        int count = userService.checkNicknameDuplicate(nickname);
        log.info("📊 DB 조회 결과 count: {}", count);
        boolean result = count > 0;
        log.info("✅ 최종 반환값 (true=중복, false=사용가능): {}", result);
        return result;
    }

    /* ================================
        1. 약관 동의
    ================================ */

    // 약관 동의 페이지
    @GetMapping("/user/signupAgreement")
    public String signupAgreement() {
        return "user/signupAgreement";
    }

    // 약관 동의 처리
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
        2. 정보 입력
    ================================ */

    // 정보 입력 페이지
    @GetMapping("/user/signupInsertInfo")
    public String signupInsertInfo() {
        return "user/signupInsertInfo";
    }
    
 // 아이디 찾기 페이지
    @GetMapping("/user/searchId")
    public String searchIdForm() {
        return "user/searchId";
    }

    // 아이디 찾기 처리 (AJAX)
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
            
            // 이름, 이메일, 전화번호로 사용자 조회
            UserVO user = userService.findUserByNameEmailPhone(name, email, phone);
            
            if (user != null) {
                // 아이디 마스킹 처리 (앞 3자리만 보여주고 나머지 *)
                String maskedId = maskUserId(user.getUserId());
                
                response.put("success", true);
                response.put("userId", maskedId);
                response.put("enrollDate", user.getCreatedAt()); // 가입일
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

    // 아이디 마스킹 처리
    private String maskUserId(String userId) {
        if (userId == null || userId.length() <= 3) {
            return userId;
        }
        
        String visible = userId.substring(0, 3);
        String masked = "*".repeat(userId.length() - 3);
        return visible + masked;
    }
    
    // 정보 입력 처리
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

        // 1) 비밀번호 일치 확인
        if (!password.equals(password2)) {
            return "redirect:/user/signupInsertInfo?error=password";
        }

        // 🔥 2) 이메일 인증 여부 체크 — 여기 추가됨!
        Boolean emailVerified = (Boolean) session.getAttribute("emailVerified");
        if (emailVerified == null || !emailVerified) {
            return "redirect:/user/signupInsertInfo?error=emailNotVerified";
        }

        // 3) 아이디 중복 체크
        int userIdCount = userService.checkUserIdDuplicate(userid);
        if (userIdCount > 0) {
            return "redirect:/user/signupInsertInfo?error=duplicateId";
        }

        // 4) 닉네임 중복 체크
        int nicknameCount = userService.checkNicknameDuplicate(nickname);
        if (nicknameCount > 0) {
            return "redirect:/user/signupInsertInfo?error=duplicateNickname";
        }

        try {
            // 이메일 합치기
            String email = emailId + "@" + emailDomain;

            // 주민번호 + 나이 계산
            String userSerialNo = birthDate + "-" + genderDigit;
            int birthYear = Integer.parseInt(birthDate.substring(0, 2));

            if (genderDigit.equals("1") || genderDigit.equals("2")) {
                birthYear += 1900;
            } else {
                birthYear += 2000;
            }

            int age = java.time.Year.now().getValue() - birthYear + 1;

            // 🔥 이메일도 세션에 저장
            session.setAttribute("email", email);

            // 나머지 입력 정보 세션에 저장
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
        3. 설문조사
    ================================ */

    // 설문조사 페이지
    @GetMapping("/user/signupSurvey")
    public String showSignupSurvey() {
        return "user/signupSurvey";
    }
    
    @GetMapping("/user/signupSuccess")
    public String signupSuccess() {
        return "user/signupSuccess";
    }
    
    // 설문조사 처리
    @PostMapping("/user/signupSurvey")
    public String signupSurveyProcess(
            @RequestParam(required = false) String interests,
            @RequestParam(required = false) String times,
            @RequestParam(required = false) String addresses,
            HttpSession session
    ) {
        try {
            // 1) 저장된 회원가입 정보 가져오기
            String userId = (String) session.getAttribute("userId");
            String password = (String) session.getAttribute("password");
            String name = (String) session.getAttribute("name");
            String nickname = (String) session.getAttribute("nickname");
            String email = (String) session.getAttribute("email");
            String phone = (String) session.getAttribute("phone");
            String userSerialNo = (String) session.getAttribute("userSerialNo");
            Integer age = (Integer) session.getAttribute("age");

            // 세션 데이터 검증 강화
            if (userId == null || password == null || name == null || 
                nickname == null || email == null || phone == null || 
                userSerialNo == null || age == null) {
                log.error("세션 데이터 누락 - userId: {}, password: {}, name: {}, nickname: {}, email: {}, phone: {}, userSerialNo: {}, age: {}", 
                         userId, password != null, name, nickname, email, phone, userSerialNo, age);
                return "redirect:/user/signupInsertInfo?error=session";
            }

            // 비밀번호 암호화
            String encodedPassword = passwordEncoder.encode(password);

            // 2) USER 객체 생성
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

            log.info("회원가입 진행 - 아이디: {}, 닉네임: {}, 나이: {}", userId, nickname, age);
            log.info("User 객체: {}", user);

            // 3) USER INSERT
            int result = userService.insertUser(user);
            log.info("USER INSERT 결과: {}", result);

            if (result > 0) {
                // 4) USER_NO 조회
                int userNo = userService.selectUserNoByUserId(userId);
                log.info("조회된 USER_NO: {}", userNo);
                
                if (userNo > 0) {
                    // 5) 설문 데이터 저장 (null 체크)
                    if (interests != null || times != null || addresses != null) {
                        log.info("설문 데이터 저장 - interests: {}, times: {}, addresses: {}", 
                                interests, times, addresses);
                        userService.insertUserInterest(
                            userNo, 
                            interests != null ? interests : "", 
                            times != null ? times : "", 
                            addresses != null ? addresses : ""
                        );
                    } else {
                        log.info("설문 데이터 없음 - 건너뜀");
                    }
                    
                    log.info("✅ 회원가입 완료 - USER_NO: {}", userNo);
                    
                    // 가입 완료 → 세션 삭제
                    session.invalidate();
                    
                    return "redirect:/user/signupSuccess";
                } else {
                    log.error("❌ USER_NO 조회 실패 - userId: {}", userId);
                    return "redirect:/user/signupSurvey?error=fail";
                }
            } else {
                log.error("❌ 회원 INSERT 실패 - userId: {}", userId);
                return "redirect:/user/signupSurvey?error=fail";
            }

        } catch (Exception e) {
            log.error("❌ 회원가입 처리 중 오류 발생", e);
            e.printStackTrace();
            return "redirect:/user/signupSurvey?error=exception";
        }
    }
    @GetMapping("/user/login")
    public String loginForm() {
        return "user/login"; // login.jsp
    }

    @PostMapping("/user/login")
    public String loginProcess(@RequestParam String userId,
                               @RequestParam String userPw,
                               HttpSession session,
                               Model model) {

        UserVO user = userService.selectUserById(userId);

        if(user != null && passwordEncoder.matches(userPw, user.getUserPw())) {
            // 정지 상태 체크
            if ("정지".equals(user.getStatus())) {
                java.sql.Timestamp until = user.getUpdatedAt();
                java.time.Instant now = java.time.Instant.now();
                if (until == null || until.toInstant().isAfter(now)) {
                    model.addAttribute("errorMsg", "해당 계정은 정지 상태입니다. 해제 예정일: " +
                            (until != null ? until.toLocalDateTime().toLocalDate() : "미정"));
                    return "user/login";
                }
            }
            session.setAttribute("loginUser", user);
            session.setAttribute("userNo", user.getUserNo());
            session.setAttribute("userNickname", user.getUserNickname());
            session.setAttribute("userType", user.getUserType());
            session.setAttribute("loginUserEmail", user.getUserEmail());

            // 권한별 리다이렉트
            if ("SYSTEM_MANAGER".equalsIgnoreCase(user.getUserType())) {
                return "redirect:http://localhost:5173/admin";
            } else if ("STADIUM_MANAGER".equalsIgnoreCase(user.getUserType())) {
                return "redirect:http://localhost:5173/stadium";
            } else {
                return "redirect:/"; // USER 및 기타
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
}


