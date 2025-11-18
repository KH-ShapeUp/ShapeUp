package com.ShapeUp.boot.app.user.controller;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.ShapeUp.boot.domain.user.model.service.UserService;
import com.ShapeUp.boot.domain.user.model.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final BCryptPasswordEncoder passwordEncoder;

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
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam String birthDate,
            @RequestParam String genderDigit,
            HttpSession session
    ) {
        if (!password.equals(password2)) {
            return "redirect:/user/signupInsertInfo?error=password";
        }

        try {
            String userSerialNo = birthDate + "-" + genderDigit;
            int birthYear = Integer.parseInt(birthDate.substring(0, 2));
            if (genderDigit.equals("1") || genderDigit.equals("2")) {
                birthYear += 1900;
            } else {
                birthYear += 2000;
            }

            int age = java.time.Year.now().getValue() - birthYear + 1;

            session.setAttribute("userId", userid);
            session.setAttribute("password", password);
            session.setAttribute("name", name);
            session.setAttribute("nickname", nickname);
            session.setAttribute("email", email);
            session.setAttribute("phone", phone);
            session.setAttribute("userSerialNo", userSerialNo);
            session.setAttribute("age", age);

            return "redirect:/user/signupSurvey";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/user/signupInsertInfo?error=exception";
        }
    }

    // ❗ GET 핸들러 추가 (Survey 페이지 보여주기)
    @GetMapping("/user/signupSurvey")
    public String showSignupSurvey() {
        return "user/signupSurvey"; // JSP 파일 위치
    }

    @PostMapping("/user/signupSurvey")
    public String signupSurveyProcess(
            @RequestParam(required=false) String interests,
            @RequestParam(required=false) String times,
            @RequestParam(required=false) String addresses,
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

            if (userId == null || password == null || name == null) {
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
                session.invalidate();
                return "redirect:/user/signupSuccess";
            } else {
                return "redirect:/user/signupSurvey?error=fail";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/user/signupSurvey?error=exception";
        }
    }
}
