class BetSetController < Controller
    helper :blue_form

    layout(:default) { !request.xhr? }

    def create(group_id=nil)
        login_required

        if group_id.nil? or group_id == "public"
            group_id = nil
        else
            group_id = group_id.to_i
        end

        if request.post?
            puts request.inspect
            game_type = request[:game_type].split("|")
            if request[:group_id].to_i == 0
                group_id = nil
            else
                group_id = request[:group_id].to_i
            end
            @bet_set = BetSet.new(
                :user_id => user.id,
                :group_id => group_id,
                :survival_pickem => game_type[0].to_i,
                :headsup_ats => game_type[1].to_i,
                :regular_reverse => game_type[2].to_i
            )
            errors = @bet_set.validate
            if not errors.empty?
                #flash[:message] = errors[0]
                #TODO: ...handle this in ajax land?
            else
                @bet_set.save
            end
        end
        @form_data = build_form_data(group_id)
    end

    private
    def build_form_data(group_id)
        login_required

        form_data = OpenStruct.new
        form_data.group_id = group_id
        #for groups we need to actually build the list of types allowed
        form_data.game_type = {
            "0|0|0" => "Eliminator",
            "0|0|1" => "Reverse Eliminator",
            "0|1|0" => "ATS Eliminator",
            "0|1|1" => "Reverse ATS Eliminator",
            "1|0|0" => "Pickem",
            "1|0|1" => "Reverse Pickem",
            "1|1|0" => "ATS Pickem",
            "1|1|1" => "Reverse ATS Pickem"
        }
        #prune down the game_type to only the ones we don't already have
        current_bet_sets = BetSet.where(
            :user_id => user.id,
            :group_id => group_id
        )
        current_bet_sets.each do |bet_set|
            survival_pickem = (bet_set.survival_pickem)?1:0
            headsup_ats = (bet_set.headsup_ats)?1:0
            regular_reverse = (bet_set.regular_reverse)?1:0
            key = "#{survival_pickem}|#{headsup_ats}|#{regular_reverse}"
            form_data.game_type.delete(key)
        end
        #remove bet types not allowed by the group
        if not group_id.nil?
            group = Group[group_id]
            if not group.survival_allowed
                form_data.game_type.delete("0|0|0")
                form_data.game_type.delete("0|0|1")
                form_data.game_type.delete("0|1|0")
                form_data.game_type.delete("0|1|1")
            end
            if not group.pickem_allowed
                form_data.game_type.delete("1|0|0")
                form_data.game_type.delete("1|0|1")
                form_data.game_type.delete("1|1|0")
                form_data.game_type.delete("1|1|1")
            end
            if not group.headsup_allowed
                form_data.game_type.delete("0|0|0")
                form_data.game_type.delete("0|0|1")
                form_data.game_type.delete("1|0|0")
                form_data.game_type.delete("1|0|1")
            end
            if not group.ats_allowed
                form_data.game_type.delete("0|1|0")
                form_data.game_type.delete("0|1|1")
                form_data.game_type.delete("1|1|0")
                form_data.game_type.delete("1|1|1")
            end
            if not group.regular_allowed
                form_data.game_type.delete("0|0|1")
                form_data.game_type.delete("0|1|1")
                form_data.game_type.delete("1|0|1")
                form_data.game_type.delete("1|1|1")
            end
            if not group.reverse_allowed
                form_data.game_type.delete("0|0|0")
                form_data.game_type.delete("0|1|0")
                form_data.game_type.delete("1|0|0")
                form_data.game_type.delete("1|1|0")
            end
        end

        form_data
    end
end
