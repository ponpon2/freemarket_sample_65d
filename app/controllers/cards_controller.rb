class CardsController < ApplicationController
  require "payjp"
  
  #Cardの新規作成
  def new
    card = Card.where(user_id: current_user.id)
    redirect_to action: "show" if card.present?
  end

  #payjpとCardのデータベース作成
  def pay
    Payjp.api_key = Rails.application.secrets.payjp_private_key
    if params['payjp-token'].blank?
      redirect_to action: "new"
    else
      customer = Payjp::Customer.create(card: params['payjp-token'])
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to action: "show"
      else
        redirect_to action: "pay"
      end
    end
  end

  #CardのデータをPayjpに送って情報を取り出す
  def show
    card = Card.where(user_id: current_user.id).first
    if card.present?
      Payjp.api_key = Rails.application.secrets.payjp_private_key
      customer = Payjp::Customer.retrieve(card.customer_id)
      @card_information = customer.cards.retrieve(card.card_id)
    else
      redirect_to action: "new" 
    end
  end

  #PayjpとCardデータベースを削除
  def delete
    card = Card.where(user_id: current_user.id).first
    if card.present?
      Payjp.api_key = Rails.application.secrets.payjp_private_key
      customer = Payjp::Customer.retrieve(card.customer_id)
      customer.delete
      card.delete
    end
      redirect_to action: "new"
  end

end
