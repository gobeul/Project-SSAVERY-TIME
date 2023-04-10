package com.ssafy.ssafytime.db.dto.lunchMenu;

import com.ssafy.ssafytime.db.entity.lunchmenu.LunchMenuEntity;
import lombok.*;

/* 점심메뉴 (오늘, 내일, 주간) 조회 DTO(develop_AJH) */
@Getter
@ToString
public class LunchMenuResponseDto {
    private Long id;
    private String mainMenu;
    private String[] sideMenu;
    private int kcal;
    private String imageUrl;

    @Builder
    public LunchMenuResponseDto(LunchMenuEntity lunchMenuEntity) {
        this.id = lunchMenuEntity.getId();
        this.mainMenu = lunchMenuEntity.getMainMenu();
        // side menu : String -> Array
        String[] sideMenuList = lunchMenuEntity.getSideMenu().split(",");
        for (int i=0; i < sideMenuList.length; i++) {
            sideMenuList[i] = sideMenuList[i].replace(" ", "");
        }
        this.sideMenu = sideMenuList;
        this.kcal = lunchMenuEntity.getKcal();
        this.imageUrl = lunchMenuEntity.getImageUrl();
    }
}
