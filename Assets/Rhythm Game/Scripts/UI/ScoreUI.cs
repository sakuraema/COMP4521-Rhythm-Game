using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ScoreUI : MonoBehaviour
{
	public Slider progressBar;
	public Text score;

	private bool m_OnProgress = true;

	protected void Update()
	{
		if (m_OnProgress)
		{
			long totalScore = ScoreManager.instance.PerfectCount * 300 + ScoreManager.instance.GoodCount * 100;
			score.text = totalScore.ToString("D9");

			var musicSource = MusicPlayer.instance.GetComponent<AudioSource>();
			progressBar.value = musicSource.time / musicSource.clip.length;

			if (progressBar.value == 1f)
			{
				m_OnProgress = false;
			} 
		}
	}
}
