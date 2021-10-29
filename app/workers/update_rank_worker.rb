class UpdateRankWorker
  include Sidekiq::Worker

  def perform(collection_id)
    ActiveRecord::Base.connection.execute("UPDATE assets a
    SET rank = a2.seqnum
    from (select a2.*, row_number() over (ORDER BY elo_rating DESC) as seqnum
          from assets a2 WHERE a2.collection_id = #{collection_id}
         ) a2
    where a2.id = a.id;");
  end
end
