using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using PlayFab;
using PlayFab.ClientModels;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class Leaderboard : MonoBehaviour
{
	public LeaderboardStatistic leaderboardStatisticPrefab;
	public Transform content;

	private List<LeaderboardStatistic> m_LeaderboardStatistics = new List<LeaderboardStatistic>();

	public List<LeaderboardStatistic> Stats { get; }

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
		m_LeaderboardStatistics.Clear();
		foreach (Transform child in content.transform)
		{
			Destroy(child.gameObject);
		}
		foreach (var item in result.Leaderboard)
		{
			m_LeaderboardStatistics.Add(Instantiate(leaderboardStatisticPrefab, content));
			SetLeaderboard(item.Position, item.DisplayName, item.StatValue);
			Debug.Log(string.Format(("{0} {1} {2}"), item.Position, item.DisplayName, item.StatValue));
		}
	}

	private void SetLeaderboard(int rank, string id, int score)
	{
		var statsItem = m_LeaderboardStatistics[rank];

		if (id == SystemInfo.deviceUniqueIdentifier)
		{
			statsItem.rank.color = Color.red;
			statsItem.playerId.color = Color.red;
			statsItem.score.color = Color.red;
		}
		statsItem.rank.text = (rank + 1).ToString();
		statsItem.playerId.text = id;
		statsItem.score.text = score.ToString();
	}

	private void OnError(PlayFabError error)
	{
		Debug.Log("Error while logging in/creating account");
		Debug.Log(error.GenerateErrorReport());
	}
}
