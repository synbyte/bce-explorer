module BceExplorer
  # block info report
  class BlockReport
    def initialize(db)
      @block = db.block
      @tx = db.tx
    end

    def call(blk)
      # this snippet to check if given param is int
      blk = blk.to_i if blk.to_i.to_s == blk
      res = @block[blk]
      res.tx.map! do |tx|
        doc = @tx[tx['txid']]
        Entities::Transaction.create_from(doc) unless doc.nil?
      end unless res.nil?
      res
    end
  end
end
