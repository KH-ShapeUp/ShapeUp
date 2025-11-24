package com.ShapeUp.boot.app.admin.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminSpaController {

    @GetMapping({"/admin", "/admin/{path:^(?!api$)[^\\.]*}", "/admin/{path:^(?!api$)[^\\.]*}/**"})
    public String forwardAdmin() {
        // Forward SPA routes under /admin to the built React index
        return "forward:/admin/index.html";
    }
}
