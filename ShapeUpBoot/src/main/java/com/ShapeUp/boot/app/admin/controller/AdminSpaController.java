package com.ShapeUp.boot.app.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Serve the built admin SPA from /src/main/resources/static/admin.
 * For admin routes without a file extension, forward to index.html.
 * Static assets (paths containing ".") are left to the resource handler.
 */
@Controller
public class AdminSpaController {

    @GetMapping(value = {"/admin", "/admin/"}, produces = MediaType.TEXT_HTML_VALUE)
    public String adminRoot() {
        return "forward:/admin/index.html";
    }

    // Exclude assets and any path containing a dot to prevent forward loops
    @GetMapping(value = "/admin/{path:^(?!assets|mock|.*\\..*$).*$}/**", produces = MediaType.TEXT_HTML_VALUE)
    public String adminNested() {
        return "forward:/admin/index.html";
    }
}
