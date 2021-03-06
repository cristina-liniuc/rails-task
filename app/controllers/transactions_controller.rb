class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /transactions
  def index
    @transactions = Transaction.where(account_id: params[:account_id])
  end

  # GET /transactions/1
  def show; end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit; end

  # POST /transactions
  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to @transaction, notice: 'Transaction was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      # redirect_to @transaction, notice: 'Transaction was successfully updated.'
      p 'Transaction updated'
    else
      p 'NO Transaction UPDATE'
      # render :edit
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: 'Transaction was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:transaction_id, :mode, :status, :made_on, :amount, :currency_code,
                                        :description, :origiinal_amount, :original_currency_code)
  end
end
