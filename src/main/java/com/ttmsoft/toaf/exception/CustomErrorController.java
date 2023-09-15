package com.ttmsoft.toaf.exception;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CustomErrorController implements ErrorController {

	@RequestMapping("/error")
    public String handleError() {
        // 커스텀 에러 페이지로 리다이렉트
        return "err"; // err.html 파일을 사용하도록 설정
    }

    @Override
    public String getErrorPath() {
        return "/error";
    }
}