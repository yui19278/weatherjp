class SearchHistory < ApplicationRecord
    # Validations
    validates :user_token, presence: true
    validates :location, presence: true

    # 直近五件を降順取得
    scope :recent, -> { order(created_at: :desc).limit(5) }

    # 履歴を挿入or更新
    def self.record!(user_token, location)
        upsert(
            { user_token: user_token, location: location },
            unique_by: [:user_token, :location],
        )
    end

    # 履歴を5件にする
    def self.limit_to_five!(user_token, limit = 5)
        # 五件保持→他削除
        keep = where(user_token: user_token).order(updated_at: :desc).limit(limit).pluck(:id)
        where(user_token: user_token).where.not(id: keep).delete_all
    end

end
