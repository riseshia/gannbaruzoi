defmodule Gannbaruzoi.AuthTest do
  use Gannbaruzoi.GraphCase

  alias Gannbaruzoi.{User, Repo}

  @email "hey!@gmail.com"
  @password "alice1234"

  describe "mutation createSession" do
    document(
      """
      mutation($clientMutationId: String!,
               $email: String!,
               $password: String!) {
        createSession(input: {
          clientMutationId: $clientMutationId,
          email: $email,
          password: $password
        }) {
          auth {
            uid
            client
            accessToken
          }
        }
      }
      """
    )

    test "returns session info", %{document: document} do
      insert!(:user, %{email: @email, password: @password})
      variables = %{
        "clientMutationId" => "1",
        "email" => @email,
        "password" => @password
      }
      result = execute_query(document, variables: variables)

      assert {:ok, %{data: %{"createSession" => %{"auth" => auth}}}} = result
      assert ~w(accessToken client uid) == Map.keys(auth)
    end

    test "fails to create with invalid email", %{document: document} do
      insert!(:user, %{email: @email, password: @password})
      variables = %{
        "clientMutationId" => "1",
        "email" => "aaaa",
        "password" => @password
      }
      result = execute_query(document, variables: variables)

      assert {:ok, %{errors: errors}} = result
      assert 1 == length(errors)
    end

    test "fails to create with invalid password", %{document: document} do
      insert!(:user, %{email: @email, password: @password})
      variables = %{
        "clientMutationId" => "1",
        "email" => @email,
        "password" => "hahaha"
      }
      result = execute_query(document, variables: variables)

      assert {:ok, %{errors: errors}} = result
      assert 1 == length(errors)
    end
  end

  describe "mutation deleteSession" do
    document(
      """
      mutation($clientMutationId: String!, $client: String!) {
        deleteSession(input: {
          clientMutationId: $clientMutationId,
          client: $client
        }) {
          result
        }
      }
      """
    )

    test "deletes token with valid args", %{document: document} do
      insert!(:user, %{email: @email, password: @password})
      auth = generate_auth()
      user = Repo.get_by!(User, email: @email)

      variables = %{
        "clientMutationId" => "1",
        "client" => auth.client,
      }
      result = execute_query(document,
                             variables: variables,
                             context: %{current_user: user})

      assert {:ok, %{data: %{"deleteSession" => %{"result" => "ok"}}}} = result
    end

    test "fails to delete token with invalid client", %{document: document} do
      insert!(:user, %{email: @email, password: @password})
      generate_auth()
      user = Repo.get_by!(User, email: @email)
      variables = %{
        "clientMutationId" => "1",
        "client" => "invalid",
      }
      result = execute_query(document,
                             variables: variables,
                             context: %{current_user: user})

      assert {:ok, %{errors: errors}} = result
      assert 1 == length(errors)
    end

    test "fails to delete token when not login", %{document: document} do
      insert!(:user, %{email: @email, password: @password})
      variables = %{
        "clientMutationId" => "1",
        "client" => "invalid",
      }
      result = execute_query(document, variables: variables)

      assert {:ok, %{errors: errors}} = result
      assert 1 == length(errors)
    end
  end

  defp generate_auth do
    Repo.get_by!(User, email: @email)
    |> User.build_session()
    |> Repo.update!()
    |> Map.get(:auth)
  end
end

