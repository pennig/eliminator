class GroupController < Controller
    helper :blue_form

    def index
        redirect UserController.r(:login) unless logged_in?
        @title = "Groups"
        @owned = user.owned_groups
        @joined = user.joined_groups
    end

    def create
        redirect UserController.r(:login) unless logged_in?
        @title = "Create Group"

        if request.post?
            puts request.inspect
            group = Group.create(
                :owner_id => user.id,
                :created_at => Time.now,
                :updated_at => Time.now,
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
            redirect GroupController.r(:view, group.id)
        end
    end

    def view(group_id)
        @group = Group[group_id]
        @title = "Group #{group_id}"
    end

    def search
        @title = "Group Search"
        @searched = request.params.size > 0
        @terms = OpenStruct.new({:name => request[:name]})
        @results = Group.where(:name.like("%#{request[:name]}%"))
    end

    def join(group_id)
        redirect UserController.r(:login) unless logged_in?
        group = Group[group_id]
        group.add_member(user.id) unless group.is_member?(user.id)
        redirect GroupController.r(:view, group_id)
    end

    def leave(group_id)
        redirect UserController.r(:login) unless logged_in?
        group = Group[group_id]
        group.remove_member(user.id) if group.is_member?(user.id)
        redirect GroupController.r(:view, group_id)
    end

end
