using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ScoreUI : MonoBehaviour
{
	public Slider progressBar;
	public Text score;

	protected void Update()
	{
		long totalScore = LevelManager.instance.Score;
		score.text = totalScore.ToString("D9");

		var musicSource = MusicPlayer.instance.GetComponent<AudioSource>();
		var progress = musicSource.time / musicSource.clip.length;
		if (progressBar.value < progress)
			progressBar.value = progress;
	}
}
