class ScheduleController < Controller
    def index(season=current_season, week_type=current_week_type, week_number = "all")
        @title = "Schedule for #{season} Week #{week_number}"
        @season = season
        @season_path = build_path

        dataset = VScheduleAndResults.where(:season => season, :week_type => week_type)
        if week_number != "all"
            dataset = dataset.where(:week_number => week_number)
        end

        @schedule = dataset.all
    end
end
