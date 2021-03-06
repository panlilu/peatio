module Private
  class HistoryController < BaseController
    def account
      @market = current_market

      @deposits = Deposit.where(member: current_user).with_aasm_state(:accepted)
      @withdraws = Withdraw.where(member: current_user).with_aasm_state(:done)

      @transactions = (@deposits + @withdraws).sort_by {|t| -t.created_at.to_i }
      @transactions = Kaminari.paginate_array(@transactions).page(params[:page]).per(20)
    end

    def trades
      @trades = current_user.trades
        .includes(:ask_member).includes(:bid_member)
        .order('id desc').page(params[:page]).per(20)
    end

    def orders
      @orders = current_user.orders.includes(:trades).order("id desc").page(params[:page]).per(20)
    end

  end
end
