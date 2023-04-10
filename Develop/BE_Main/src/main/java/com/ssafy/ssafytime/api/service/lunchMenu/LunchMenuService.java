package com.ssafy.ssafytime.api.service.lunchMenu;

import com.ssafy.ssafytime.db.dto.lunchMenu.LunchMenuDetailResponseDto;
import com.ssafy.ssafytime.db.dto.lunchMenu.LunchMenuResponseDto;

import java.util.HashMap;
import java.util.List;

public interface LunchMenuService {

    List<LunchMenuResponseDto> getTodayMenu(int region);

    List<LunchMenuResponseDto> getTomorrowMenu(int region);

    LunchMenuDetailResponseDto getMenuDetail(Long id);

    HashMap<Integer, List<LunchMenuResponseDto>> getWeekMenu(int region);
}
