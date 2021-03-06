class BetSet
    self.plugin :timestamps

    def friendly_name
        link_array = []
        if self.regular_reverse
            link_array.push("Reverse")
        end
        if self.headsup_ats
            link_array.push("ATS")
        end
        if self.survival_pickem
            link_array.push("Pickem")
        else
            link_array.push("Eliminator")
        end
        link_array.join(" ")
    end

    def validate
        errors = []
        if not self.group_id.nil?
            group = Group[self.group_id]
            if not group.is_member?(self.user_id)
                errors << "Not a member of this group"
            end

            if self.survival_pickem == false and group.survival_allowed == false
                errors << "Eliminator is not an allowed bet type for this group"
            end
            if self.survival_pickem == true and group.pickem_allowed == false
                errors << "Pickem is not an allowed bet type for this group"
            end
            if self.headsup_ats == false and group.headsup_allowed == true
                errors << "Heads up is not an allowed bet type for this group"
            end
            if self.headsup_ats == true and group.ats_allowed == false
                errors << "Against the spread is not an allowed bet type for this group"
            end
            if self.regular_reverse == false and group.regular_allowed == false
                errors << "Regular play is not an allowed bet type for this group"
            end
            if self.regular_reverse == true and group.reverse_allowed == false
                errors << "Reverse play is not an allowed bet type for this group"
            end
        end

        existing_bet_set = BetSet.where(:user_id => self.user_id,
            :group_id => self.group_id,
            :survival_pickem => self.survival_pickem,
            :headsup_ats => self.headsup_ats,
            :regular_reverse => self.regular_reverse)
        if existing_bet_set.count > 0
            errors << "This bet set already exists"
        end
        errors
    end
end
