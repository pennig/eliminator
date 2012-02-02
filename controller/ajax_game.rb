class AjaxGameController < Controller
    layout nil
    map "/ajax/game"
    def bet_popover(game_id)
        @schedule = VScheduleAndResults.where(:game_id => game_id).first
    end
end
