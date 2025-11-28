package com.ShapeUp.boot.app.admin.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class AdminSpaController {

    /**
     * Catch-all for admin SPA routes, but skip real static files and API paths to avoid forward loops.
     */
    @GetMapping({"/admin", "/admin/", "/admin/{path:^(?!assets|mock|api|index\\.html$).*$}/**"})
    public String forwardAdmin(HttpServletRequest request, @PathVariable(value = "path", required = false) String path) {
        return "forward:/admin/index.html";
    }
}
