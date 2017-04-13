defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
        get(conn, video_path(conn, :new)),
        get(conn, video_path(conn, :index)),
        get(conn, video_path(conn, :show, "123")),
        get(conn, video_path(conn, :edit, "123")),
        get(conn, video_path(conn, :update, "123")),
        get(conn, video_path(conn, :create, %{})),
        get(conn, video_path(conn, :delete, "123"))
      ], fn conn ->
        assert html_response(conn, 303)
        assert conn.halted
      end)
  end

  setup %{conn: conn} = config do
    if username = config[:login_as] do 
      user = insert_user(username: username)
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  @tag login_as: "max"
  test "lists all user's videos on index", %{conn: conn, user: user} do
    user_video = insert_video(user, title: "funny cats")
    other_video = insert_video(insert_user(username: "other", title: "another video"))

    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ ~r/Listing videos/
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, other_video.title)
  end

  # alias Rumbl.Video
  # @valid_attrs %{" url": "some content", description: "some content", title: "some content"}
  # @invalid_attrs %{}

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, video_path(conn, :index)
  #   assert html_response(conn, 200) =~ "Listing videos"
  # end

  # test "renders form for new resources", %{conn: conn} do
  #   conn = get conn, video_path(conn, :new)
  #   assert html_response(conn, 200) =~ "New video"
  # end

  # test "creates resource and redirects when data is valid", %{conn: conn} do
  #   conn = post conn, video_path(conn, :create), video: @valid_attrs
  #   assert redirected_to(conn) == video_path(conn, :index)
  #   assert Repo.get_by(Video, @valid_attrs)
  # end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, video_path(conn, :create), video: @invalid_attrs
  #   assert html_response(conn, 200) =~ "New video"
  # end

  # test "shows chosen resource", %{conn: conn} do
  #   video = Repo.insert! %Video{}
  #   conn = get conn, video_path(conn, :show, video)
  #   assert html_response(conn, 200) =~ "Show video"
  # end

  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent 404, fn ->
  #     get conn, video_path(conn, :show, -1)
  #   end
  # end

  # test "renders form for editing chosen resource", %{conn: conn} do
  #   video = Repo.insert! %Video{}
  #   conn = get conn, video_path(conn, :edit, video)
  #   assert html_response(conn, 200) =~ "Edit video"
  # end

  # test "updates chosen resource and redirects when data is valid", %{conn: conn} do
  #   video = Repo.insert! %Video{}
  #   conn = put conn, video_path(conn, :update, video), video: @valid_attrs
  #   assert redirected_to(conn) == video_path(conn, :show, video)
  #   assert Repo.get_by(Video, @valid_attrs)
  # end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   video = Repo.insert! %Video{}
  #   conn = put conn, video_path(conn, :update, video), video: @invalid_attrs
  #   assert html_response(conn, 200) =~ "Edit video"
  # end

  # test "deletes chosen resource", %{conn: conn} do
  #   video = Repo.insert! %Video{}
  #   conn = delete conn, video_path(conn, :delete, video)
  #   assert redirected_to(conn) == video_path(conn, :index)
  #   refute Repo.get(Video, video.id)
  # end
end
