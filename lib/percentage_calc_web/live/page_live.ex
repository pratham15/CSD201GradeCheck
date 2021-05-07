defmodule PercentageCalcWeb.PageLive do
  use PercentageCalcWeb, :live_view

  alias PercentageCalc.Entries

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       error: "",
       name: "",
       email: "",
       quiz1: "",
       quiz2: "",
       quiz3: "",
       till_now: "",
       end_sem: "",
       total: "",
       done: false
     )}
  end

  @impl true
  def handle_event("calculate", state, socket) do
    error = validate(state)

    if error != nil do
      {:noreply, socket |> put_flash(:error, error)}
    else
      {till_now, end_sem, total} = calc(state)

      try do
        Entries.create_entry(%{
          email: state["email"],
          name: state["name"],
          percentage: total
        })

        {
          :noreply,
          assign(
            socket,
            till_now: :erlang.float_to_binary(till_now, decimals: 2),
            end_sem: :erlang.float_to_binary(end_sem, decimals: 2),
            total: :erlang.float_to_binary(total, decimals: 2),
            done: true
          )
        }
      rescue
        _a ->
          {
            :noreply,
            assign(socket, error: "User already calculated")
          }
      end
    end
  end

  def handle_event("view_stats", _, socket) do
    {:noreply, redirect(socket, external: "/stats")}
  end

  defp calc(state) do
    %{
      "quiz1" => quiz1_r,
      "quiz2" => quiz2_r,
      "quiz3" => quiz3_r,
      "lab1" => lab1_r,
      "lab2" => lab2_r,
      "objective" => objective_r,
      "subjective" => subjective_r,
      "part" => part_r
    } = state

    {quiz1, _} = Float.parse(quiz1_r)
    {quiz2, _} = Float.parse(quiz2_r)
    {quiz3, _} = Float.parse(quiz3_r)
    {lab1, _} = Float.parse(lab1_r)
    {lab2, _} = Float.parse(lab2_r)
    {objective, _} = Float.parse(objective_r)
    {subjective, _} = Float.parse(subjective_r)
    {part, _} = Float.parse(part_r)

    quiz = (quiz1 / 15 + quiz2 / 15 + quiz3 / 10) * 5
    lab = (lab1 / 5 + lab2 / 7) * 10
    mid = (objective * 30 / 20 + subjective * 70 / 40) / 4

    total = quiz + lab + mid + part
    endsem = total * 35 / 65

    {total, endsem, total + endsem}
  end

  defp validate(state) do
    %{
      "name" => name,
      "email" => email,
      "quiz1" => quiz1,
      "quiz2" => quiz2,
      "quiz3" => quiz3,
      "lab1" => lab1,
      "lab2" => lab2,
      "objective" => objective,
      "subjective" => subjective,
      "part" => part
    } = state

    cond do
      name == "" ->
        "Name can't be empty"

      email == "" ->
        "Email can't be empty"

      quiz1 < 0 and quiz1 > 15 ->
        "Quiz 1 marks should be between 0 and 15"

      quiz2 < 0 and quiz2 > 15 ->
        "Quiz 2 marks should be between 0 and 15"

      quiz3 < 0 and quiz3 > 10 ->
        "Quiz 1 marks should be between 0 and 10"

      lab1 < 0 and lab1 > 5 ->
        "Lab 1 marks should be between 0 and 5"

      lab2 < 0 and lab2 > 7 ->
        "Lab 2 marks should be between 0 and 7"

      objective < 0 and objective > 20 ->
        "Objective marks should be between 0 and 20"

      subjective < 0 and subjective > 40 ->
        "Subjective marks should be between 0 and 40"

      part < 0 and part > 5 ->
        "Class participation marks should be between 0 and 5"

      true ->
        nil
    end
  end
end
