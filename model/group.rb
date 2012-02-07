class Group
    self.plugin :timestamps
    many_to_many :members, :join_table => :group_members, :class => User, :left_key => :group_id, :right_key => :user_id
    many_to_one :owner, :class => User, :key => :owner_id

    def validate
        errors = []
        if self.name.nil? or self.name.empty?
            errors << "Name is required"
        end
        if not self.pickem_allowed and not self.survival_allowed
            errors << "Must allow either pickem or survival"
        end
        if not self.headsup_allowed and not self.ats_allowed
            errors << "Must allow either heads up or against the spread"
        end
        if not self.regular_allowed and not self.reverse_allowed
            errors << "Must allow either regular or reverse"
        end
        return errors
    end

    def is_member?(user_id)
        GroupMember.where(:group_id => self.id).where(:user_id => user_id).count > 0
    end

    def add_member(user_id)
        GroupMember.create(
            :group_id => self.id,
            :user_id => user_id,
            :created_at => Time.now
        )
    end

    def remove_member(user_id)
        GroupMember.where(:group_id => self.id).where(:user_id => user_id).delete
    end
end
