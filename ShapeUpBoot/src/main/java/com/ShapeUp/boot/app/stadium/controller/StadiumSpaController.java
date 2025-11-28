package com.ShapeUp.boot.app.stadium.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class StadiumSpaController {

    /**
     * Catch-all for stadium SPA routes, skipping real static files and API paths.
     */
    @GetMapping({"/stadium", "/stadium/", "/stadium/{path:^(?!assets|mock|api|index\\.html$).*$}/**"})
    public String forwardStadium(HttpServletRequest request, @PathVariable(value = "path", required = false) String path) {
        String uri = request.getRequestURI();
        // Serve real static files directly (anything containing a dot)
        if (uri.contains(".")) {
            return null;
        }
        // If a dedicated stadium build exists, it will be served; otherwise fall back to admin SPA (which can route /stadium)
        return "forward:/admin/index.html";
    }
}
