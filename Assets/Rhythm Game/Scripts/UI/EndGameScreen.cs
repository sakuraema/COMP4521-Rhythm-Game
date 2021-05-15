using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EndGameScreen : MonoBehaviour
{
	[Header("Score and rank")]
	public Text perfectCount;
	public Text goodCount;
	public Text missedCount;
	public Text score;
	public Image rank;
	public Sprite[] rankSprites;
	[Header("Buttons and interactables")]
	public Button leaderboardButton;
	public Button backButton;
	public Leaderboard leaderboard;
	public LevelLoadingScreen loadingScreen;

	private Canvas m_Canvas;
	private int m_TotalScore;

	private void Initialize()
	{
		var scoreManager = ScoreManager.instance;
		perfectCount.text = scoreManager.PerfectCount.ToString();
		goodCount.text = scoreManager.GoodCount.ToString();
		missedCount.text = scoreManager.MissedCount.ToString();

		m_TotalScore = scoreManager.PerfectCount * 300 + scoreManager.GoodCount * 100;
		score.text = m_TotalScore.ToString();

		var maxScore = (scoreManager.PerfectCount + scoreManager.GoodCount + scoreManager.MissedCount) * 300f;
		var percentage = m_TotalScore / maxScore;
		if (percentage > .95f)
			rank.sprite = rankSprites[0]; // S
		else if (percentage > .9f)
			rank.sprite = rankSprites[1]; // A
		else if (percentage > .8f)
			rank.sprite = rankSprites[2]; // B
		else if (percentage > .6f)
			rank.sprite = rankSprites[3]; // C
		else
			rank.sprite = rankSprites[4]; // D
	}

	protected void Awake()
	{
		m_Canvas = GetComponent<Canvas>();
		m_Canvas.enabled = false;
		MusicPlayer.instance.onMusicEnd.AddListener(() => 
		{
			m_Canvas.enabled = true;
			Initialize();
			PlayFabManager.instance.SendLeaderboard(m_TotalScore);
			leaderboard.GetLeaderboard();
		});
	}
}
