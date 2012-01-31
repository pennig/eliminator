class Group
    many_to_many :members, :join_table => :group_members, :class => User, :left_key => :group_id, :right_key => :user_id
    many_to_one :owner, :class => User, :key => :owner_id
end
