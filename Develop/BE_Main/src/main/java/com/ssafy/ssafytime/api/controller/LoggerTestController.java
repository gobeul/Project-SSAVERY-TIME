package com.ssafy.ssafytime.api.controller;

import lombok.extern.log4j.Log4j2;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@Log4j2
@RestController
public class LoggerTestController {

    @GetMapping(value = "/log")
    public void log() throws Exception {

        //FATAL, ERROR, WARN, INFO, DEBUG, TRACE
        log.fatal("FATAL");
        log.error("ERROR");
        log.warn("WARN");
        log.info("INFO");
        log.debug("DEBUG");
        log.trace("TRACE");
    }

}
