class CreateTags < ActiveRecord::Migration[6.0]
  def up
    create_table :tags do |t|
      t.string :name
      t.references :team

      t.timestamps
    end

    Team.all.each do |t|
      t.tags.create name: t.name
      t.tags.create name: [t.name, t.nickname].join(" ")
      t.tags.create name: t.bovada_name
      t.tags.create name: t.bookmaker_name
    end

    Team.mlb.or(Team.nhl).or(Team.nba).or(Team.nfl).or(Team.kbo).or(Team.npb).each do |t|
      t.tags.create name: t.nickname
    end
  end

  def down
    drop_table :tags
  end
end
