using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using PlayFab;
using PlayFab.ClientModels;
using Core.Utilities;

public class PlayFabManager : PersistentSingleton<PlayFabManager>
{
	void Start()
	{
		Login();
	}

	void Login()
	{
		var request = new LoginWithCustomIDRequest();
		request.CustomId = SystemInfo.deviceUniqueIdentifier;
		request.CreateAccount = true;

		PlayFabClientAPI.LoginWithCustomID(request, OnSuccess, OnError);
	}

	private void OnSuccess(LoginResult result)
	{
		Debug.Log("Successful login/account create");
	}

	private void OnError(PlayFabError error)
	{
		Debug.Log("Error while logging in/creating account");
		Debug.Log(error.GenerateErrorReport());
	}

	private void OnLeaderboardUpdate(UpdatePlayerStatisticsResult result)
	{
		Debug.Log("Leaderboard sent successfully");
	}

	public void SendLeaderboard(int score)
	{
		var request = new UpdatePlayerStatisticsRequest
		{
			Statistics = new List<StatisticUpdate>
			{
				new StatisticUpdate
				{
					StatisticName = SceneManager.GetActiveScene().name,
					Value = score
				}
			}
		};
		PlayFabClientAPI.UpdatePlayerStatistics(request, OnLeaderboardUpdate, OnError);
	}

	public void GetLeaderboard()
	{
		var request = new GetLeaderboardRequest
		{
			StatisticName = SceneManager.GetActiveScene().name,
			StartPosition = 0,
			MaxResultsCount = 10
		};
		PlayFabClientAPI.GetLeaderboard(request, OnLeaderboardGet, OnError);
	}

	private void OnLeaderboardGet(GetLeaderboardResult result)
	{
		foreach (var item in result.Leaderboard)
		{
			Debug.Log(string.Format(("{0} {1} {2}"), item.Position, item.PlayFabId, item.StatValue));
		}
	}
}
