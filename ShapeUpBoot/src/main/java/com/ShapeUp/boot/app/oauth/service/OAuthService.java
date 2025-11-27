package com.ShapeUp.boot.app.oauth.service;

import com.ShapeUp.boot.domain.user.model.mapper.UserMapper;
import com.ShapeUp.boot.domain.user.model.vo.UserVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

@Slf4j
@Service
@RequiredArgsConstructor
public class OAuthService {

    private final UserMapper userMapper;

    @Value("${oauth.kakao.client-id}")
    private String kakaoClientId;
    @Value("${oauth.kakao.redirect-uri}")
    private String kakaoRedirectUri;
    @Value("${oauth.kakao.token-url}")
    private String kakaoTokenUrl;
    @Value("${oauth.kakao.user-info-url}")
    private String kakaoUserUrl;

    @Value("${oauth.naver.client-id}")
    private String naverClientId;
    @Value("${oauth.naver.client-secret}")
    private String naverSecret;
    @Value("${oauth.naver.redirect-uri}")
    private String naverRedirectUri;
    @Value("${oauth.naver.user-info-url}")
    private String naverUserUrl;


    /* ============================
     * 1) 카카오 로그인 URL 생성
     * ============================ */
    public String getKakaoLoginUrl() {
        // ✅ prompt=login 추가하면 매번 동의창 표시
        return "https://kauth.kakao.com/oauth/authorize?client_id=" +
                kakaoClientId +
                "&redirect_uri=" + kakaoRedirectUri +
                "&response_type=code" +
                "&prompt=login";
    }


    /* ============================
     * 2) 카카오 로그인 처리
     * @return true: 신규 회원, false: 기존 회원
     * ============================ */
    public boolean kakaoLogin(String code, HttpSession session) throws Exception {

        log.info("🔍 카카오 로그인 처리 시작");

        // 1. 액세스 토큰 요청
        String params = "grant_type=authorization_code" +
                "&client_id=" + kakaoClientId +
                "&redirect_uri=" + kakaoRedirectUri +
                "&code=" + code;

        String tokenResponse = post(kakaoTokenUrl, params);
        JSONObject tokenJson = new JSONObject(tokenResponse);

        String accessToken = tokenJson.getString("access_token");
        log.info("✅ 카카오 액세스 토큰 획득");

        // 2. 사용자 정보 요청
        String userInfo = getWithToken(kakaoUserUrl, accessToken);
        JSONObject root = new JSONObject(userInfo);

        Long kakaoId = root.getLong("id");

        JSONObject account = root.getJSONObject("kakao_account");
        JSONObject properties = root.getJSONObject("properties");

        String email = account.has("email") ? account.getString("email") : null;

        // nickname 우선순위: properties → account.profile
        String nickname = null;

        if (properties.has("nickname")) {
            nickname = properties.getString("nickname");
        } else if (account.has("profile") && account.getJSONObject("profile").has("nickname")) {
            nickname = account.getJSONObject("profile").getString("nickname");
        } else {
            nickname = "카카오사용자";
        }

        // ✅ 이메일이 없으면 임시 이메일 생성
        if (email == null || email.isBlank()) {
            email = "kakao_" + kakaoId + "@social.local";
        }

        log.info("✅ 카카오 사용자 정보 - email: {}, nickname: {}", email, nickname);

        return loginOrJoin(email, nickname, "KAKAO", session);
    }


    /* ============================
     * 3) 네이버 로그인 URL
     * ============================ */
    public String getNaverLoginUrl() {
        String state = "RANDOM_STATE_" + System.currentTimeMillis();
        // ✅ auth_type=reprompt 추가하면 매번 동의창 표시
        return "https://nid.naver.com/oauth2.0/authorize?response_type=code" +
                "&client_id=" + naverClientId +
                "&redirect_uri=" + naverRedirectUri +
                "&state=" + state +
                "&auth_type=reprompt";
    }


    /* ============================
     * 4) 네이버 로그인 처리
     * @return true: 신규 회원, false: 기존 회원
     * ============================ */
    public boolean naverLogin(String code, String state, HttpSession session) throws Exception {

        log.info("🔍 네이버 로그인 처리 시작");

        String tokenUrl =
                "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code" +
                        "&client_id=" + naverClientId +
                        "&client_secret=" + naverSecret +
                        "&code=" + code +
                        "&state=" + state;

        String tokenResponse = get(tokenUrl);
        JSONObject tokenJson = new JSONObject(tokenResponse);

        String accessToken = tokenJson.getString("access_token");
        log.info("✅ 네이버 액세스 토큰 획득");

        // 사용자 정보 요청
        String userInfo = getWithToken(naverUserUrl, accessToken);
        JSONObject res = new JSONObject(userInfo).getJSONObject("response");

        String id = res.getString("id");
        String nickname = res.getString("nickname");
        String email = res.getString("email");

        // ✅ 이메일이 없으면 임시 이메일 생성
        if (email == null || email.isBlank()) {
            email = "naver_" + id + "@social.local";
        }

        log.info("✅ 네이버 사용자 정보 - email: {}, nickname: {}", email, nickname);

        return loginOrJoin(email, nickname, "NAVER", session);
    }


    /* ============================
     * ▶ 공통: 회원 조회 → 없으면 임시 가입
     * @return true: 신규 회원, false: 기존 회원
     * ============================ */
    private boolean loginOrJoin(String email, String nickname, String provider, HttpSession session) {

        String userId = email;

        log.info("🔍 소셜 로그인 시도 - email: {}, nickname: {}, provider: {}", email, nickname, provider);

        // 1) USER_ID(이메일)로 조회
        UserVO user = userMapper.findByUserId(userId);
        
        if (user != null) {
            // ✅ 기존 회원 로그인
            log.info("✅ 기존 회원 로그인 - userNo: {}, userId: {}", user.getUserNo(), user.getUserId());
            
            session.setAttribute("userNo", user.getUserNo());
            session.setAttribute("userNickname", user.getUserNickname());
            session.setAttribute("loginUser", user);
            session.setAttribute("userType", user.getUserType());
            session.setAttribute("loginUserEmail", user.getUserEmail());
            return false; // 기존 회원
        }

        log.info("🆕 신규 회원 - 임시 가입 시작");

        // 2) 닉네임 충돌 처리
        if (userMapper.checkNicknameDuplicate(nickname) > 0) {
            nickname = nickname + "_" + System.currentTimeMillis();
            log.info("⚠️ 닉네임 충돌 - 변경된 닉네임: {}", nickname);
        }

        // 3) 신규 회원 임시 가입 (필수 정보만 저장)
        user = new UserVO();
        user.setUserId(userId);
        user.setUserPw("SOCIAL");
        user.setUserName(nickname);  // 임시로 닉네임을 이름으로 사용
        user.setUserNickname(nickname);
        user.setUserEmail(email);
        user.setUserType("USER");
        user.setStatus("정상");
        // ✅ 생년월일, 전화번호는 null로 남겨둠 (추가 정보 입력 페이지에서 받음)

        try {
            userMapper.insertSocialUser(user);
            log.info("✅ 소셜 회원 임시 가입 완료");
        } catch (Exception e) {
            log.error("❌ 소셜 회원 임시 가입 실패", e);
            throw e;
        }
        
        // INSERT 후 DB에서 user 정보 다시 조회
        user = userMapper.findByUserId(userId);
        
        if (user == null) {
            log.error("❌ INSERT 후 사용자 조회 실패 - userId: {}", userId);
            throw new RuntimeException("사용자 정보 조회 실패");
        }
        
        log.info("✅ INSERT 후 조회 완료 - userNo: {}", user.getUserNo());

        // ✅ 세션에 소셜 로그인 임시 정보 저장
        session.setAttribute("userNo", user.getUserNo());
        session.setAttribute("userNickname", user.getUserNickname());
        session.setAttribute("loginUser", user);
        session.setAttribute("userType", user.getUserType());
        session.setAttribute("loginUserEmail", user.getUserEmail());
        
        // ✅ 소셜 로그인 추가 정보 입력용 플래그
        session.setAttribute("isSocialLogin", true);
        session.setAttribute("socialName", nickname);
        session.setAttribute("socialEmail", email);
        
        log.info("✅ 세션 설정 완료 - isSocialLogin: true");
        
        return true; // 신규 회원
    }



    /* ============================
     * ▶ HTTP 요청 처리
     * ============================ */
    private String post(String urlString, String params) throws Exception {
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");
        conn.setDoOutput(true);

        BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
        bw.write(params);
        bw.flush();
        bw.close();

        return read(conn);
    }

    private String get(String urlString) throws Exception {
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        return read(conn);
    }

    private String getWithToken(String urlString, String token) throws Exception {
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + token);

        return read(conn);
    }

    private String read(HttpURLConnection conn) throws Exception {
        BufferedReader br;

        // 400/500 에러 처리
        if (conn.getResponseCode() >= 400) {
            br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        } else {
            br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        }

        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = br.readLine()) != null)
            sb.append(line);

        br.close();
        return sb.toString();
    }
}