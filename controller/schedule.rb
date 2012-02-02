class ScheduleController < Controller
    def index(season=current_season, week_type=current_week_type, week_number = current_week_number)
        @title = "Schedule for #{season} Week #{week_number}"
        dataset = VScheduleAndResults.where(:season => season, :week_type => week_type)
        if week_number != "all"
            dataset = dataset.where(:week_number => week_number)
        end

        @schedule = dataset.all
    end

    private

    def current_week_type
        "REG"
    end

    def current_week_number
        "all"
    end

end
