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

	private Canvas m_Canvas;

	private void Initialize()
	{
		perfectCount.text = LevelManager.instance.PerfectCount.ToString();
		goodCount.text = LevelManager.instance.GoodCount.ToString();
		missedCount.text = LevelManager.instance.MissedCount.ToString();

		score.text = LevelManager.instance.Score.ToString();

		float totalNote = LevelManager.instance.PerfectCount + LevelManager.instance.MissedCount + LevelManager.instance.GoodCount;
		var percentage = LevelManager.instance.PerfectCount / totalNote * 1f
			+ LevelManager.instance.GoodCount / totalNote * 0.5f;
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
			PlayFabManager.instance.SendLeaderboard(LevelManager.instance.Score);
			leaderboard.GetLeaderboard();
		});
		backButton.onClick.AddListener(() =>
		{
			StartCoroutine(LevelManager.instance.LoadSceneAsync(0));
		});
	}
}
