class Group
    many_to_many :members, :join_table => :group_members, :class => User, :left_key => :group_id, :right_key => :user_id
    many_to_one :owner, :class => User, :key => :owner_id

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
