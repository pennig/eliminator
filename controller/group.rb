class GroupController < Controller
    helper :blue_form

    def index
        login_required
        @title = "Groups"
        @owned = user.owned_groups
        @joined = user.joined_groups
    end

    def create
        login_required

        @title = "Create Group"

        if request.post?
            @group = Group.new(
                :owner_id => user.id,
                :name => request[:name],
                :public => request[:public] || false,
                :visible => request[:visible] || false,
                :pickem_allowed => request[:pickem_allowed] || false,
                :survival_allowed => request[:survival_allowed] || false,
                :headsup_allowed => request[:headsup_allowed] || false,
                :ats_allowed => request[:ats_allowed] || false,
                :regular_allowed => request[:regular_allowed] || false,
                :reverse_allowed => request[:reverse_allowed] || false
            )


            errors = @group.validate
            if not errors.empty?
                flash[:message] = errors[0]
            else
                flash[:message] = "Group created"
                @group.save
                GroupMember.create(
                    :group_id => @group.id,
                    :user_id => user.id
                )
                redirect GroupController.r(:view, @group.id)
            end
        else
            @group = OpenStruct.new
        end
    end

    def edit(group_id)
        login_required
        @group = Group[group_id]

        if @group.owner != user
            flash[:message] = "You must own a group in order to edit it"
            redirect GroupController.r(:view, @group.id)
        end

        @title = "Edit Group: #{@group.name}"

        if request.post?
            @group.updated_at = Time.now
            @group.name = request[:name]
            @group.public = request[:public] || false
            @group.visible = request[:visible] || false
            @group.pickem_allowed = request[:pickem_allowed] || false
            @group.survival_allowed = request[:survival_allowed] || false
            @group.headsup_allowed = request[:headsup_allowed] || false
            @group.ats_allowed = request[:ats_allowed] || false
            @group.regular_allowed = request[:regular_allowed] || false
            @group.reverse_allowed = request[:reverse_allowed] || false

            errors = @group.validate
            if not errors.empty?
                flash[:message] = errors[0]
            else
                flash[:message] = "Group updated"
                @group.save
                redirect GroupController.r(:view, @group.id)
            end
        end
    end

    def view(group_id)
        @group = Group[group_id]
        @title = "Group: #{@group.name}"
    end

    def search
        @title = "Group Search"
        @searched = request.params.size > 0
        @terms = OpenStruct.new({:name => request[:name]})
        @results = Group.where(:name.like("%#{request[:name]}%")).where(:visible => true)
    end

    def join(group_id)
        login_required
        group = Group[group_id]
        group.add_member(user.id) if group.public and not group.is_member?(user.id)
        redirect GroupController.r(:view, group_id)
    end

    def leave(group_id)
        login_required
        group = Group[group_id]
        group.remove_member(user.id) if group.is_member?(user.id) and group.owner_id != user.id
        redirect GroupController.r(:view, group_id)
    end

end
