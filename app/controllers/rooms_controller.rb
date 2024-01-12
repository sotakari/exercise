class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
  # 新しいメッセージルームを作成
  @room = Room.create

  # エントリーを作成し、current_userをルームに追加
  @entry1 = Entry.create(user_id: current_user.id, room_id: @room.id)

  # フォームから送信されたエントリーを作成し、相手のユーザーをルームに追加
  entry_params = params.require(:entry).permit(:user_id).merge(room_id: @room.id)
  @entry2 = Entry.create(entry_params)

  # ルームにリダイレクト
  redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
    #Roomで相手の名前表示するために記述
      @myUserId = current_user.id
    else
      redirect_back(fallback_location: root_path)
    end
  end
end
