using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EndGameScreen : MonoBehaviour
{
	public Text perfectCount;
	public Text goodCount;
	public Text missedCount;
	public Text score;

	private Canvas m_Canvas;

	void Initialize()
	{
		perfectCount.text = ScoreManager.instance.PerfectCount.ToString();
		goodCount.text = ScoreManager.instance.GoodCount.ToString();
		missedCount.text = ScoreManager.instance.MissedCount.ToString();

		long totalScore = ScoreManager.instance.PerfectCount * 300 + ScoreManager.instance.GoodCount * 100;
		score.text = totalScore.ToString();
	}

	protected void Awake()
	{
		m_Canvas = GetComponent<Canvas>();
		m_Canvas.enabled = false;
		MusicPlayer.instance.onMusicEnd.AddListener(() => 
		{
			m_Canvas.enabled = true;
			Initialize();
		});
	}
}
