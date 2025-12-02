package com.ShapeUp.boot.app.user.mail;

import java.time.LocalDateTime;
import java.util.Random;

import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MailService {

    private final JavaMailSender mailSender;
    private final Random random = new Random();

    // 인증코드 생성
    public String generateCode() {
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }

    // 이메일 전송
    public boolean sendVerificationCode(String toEmail, String code) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(toEmail);
            message.setFrom("no-reply@shapeup.example"); // 보낸사람 표시
            message.setSubject("[ShapeUp] 이메일 인증번호 안내");
            message.setText("안녕하세요, ShapeUp입니다.\n\n인증번호: " + code + "\n\n해당 코드는 5분 동안만 유효합니다.");
            mailSender.send(message);
            log.info("메일 전송 성공 -> to: {}", toEmail);
            return true;
        } catch (Exception e) {
            log.error("메일 전송 실패", e);
            return false;
        }
    }

    // 세션에 인증 코드와 만료 시간 저장
    public void storeCodeInSession(HttpSession session, String email, String code, int minutesValid) {
        session.setAttribute("emailVerificationAddress", email);
        session.setAttribute("emailVerificationCode", code);
        session.setAttribute("emailVerificationExpiresAt", LocalDateTime.now().plusMinutes(minutesValid));
    }

    // 검증 로직
    public boolean verifyCode(HttpSession session, String email, String code) {
        Object sessEmail = session.getAttribute("emailVerificationAddress");
        Object sessCode = session.getAttribute("emailVerificationCode");
        Object sessExpires = session.getAttribute("emailVerificationExpiresAt");

        if (sessEmail == null || sessCode == null || sessExpires == null) {
            return false;
        }

        if (!email.equals(sessEmail.toString())) return false;
        if (!code.equals(sessCode.toString())) return false;

        LocalDateTime expires = (LocalDateTime) sessExpires;
        if (LocalDateTime.now().isAfter(expires)) {
            // 만료
            return false;
        }

        // 검증 성공하면 세션에 플래그를 남김(또는 필요한 처리)
        session.setAttribute("emailVerified", true);
        // 인증 데이터는 더 이상 필요 없으므로 삭제(선택)
        session.removeAttribute("emailVerificationCode");
        session.removeAttribute("emailVerificationExpiresAt");
        // emailVerificationAddress는 남겨둘 수 있음
        return true;
    }
    public boolean sendTempPassword(String email, String tempPw) {
        String subject = "[ShapeUp] 임시 비밀번호 안내";
        String text = "임시 비밀번호는 다음과 같습니다:\n\n"
                + tempPw + "\n\n"
                + "로그인 후 반드시 비밀번호를 변경해주세요.";

        return sendEmail(email, subject, text);
    }
 // 공통 이메일 발송 메서드
    public boolean sendEmail(String toEmail, String subject, String text) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(toEmail);
            message.setSubject(subject);
            message.setText(text);
            message.setFrom("no-reply@shapeup.example");
            mailSender.send(message);
            return true;
        } catch (Exception e) {
            log.error("메일 전송 실패", e);
            return false;
        }
    }

    
}
