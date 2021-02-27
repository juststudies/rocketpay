defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true
  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "nicolas",
        password: "12345687",
        nickname: "elnico",
        email: "elnico@elchapo.com",
        age: 27
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic ZXN0cm9nb25vZmU6YmF0YXRhcGFpYQ==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "When all params are valid make a deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50"}
      response=
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)



      assert %{
        "account" => %{"balance" => "50.00","id" => _id},
        "message" => "Ballance changed successfully"
      } = response
    end

    test "When there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "jabulani"}
      response=
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid deposit value!"}

      assert response == expected_response
    end
  end
end
