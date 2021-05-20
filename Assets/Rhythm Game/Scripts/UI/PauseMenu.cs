using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PauseMenu : MonoBehaviour
{
	public static bool isOn = false;

	public Button pauseButton;
	public Button homeButton;
	public Button playButton;
	public Canvas blocker;

	private AudioSource m_AudioSource;

	private void Awake()
	{
		m_AudioSource = Camera.main.GetComponent<AudioSource>();
		pauseButton.onClick.AddListener(() => {
			blocker.enabled = true;
			Time.timeScale = 0f;
			m_AudioSource.Pause();
			isOn = true;
		});
		homeButton.onClick.AddListener(() =>
		{
			Time.timeScale = 1f;
			isOn = false;
			StartCoroutine(LevelManager.instance.LoadSceneAsync(0));
		});
		playButton.onClick.AddListener(() =>
		{
			blocker.enabled = false;
			Time.timeScale = 1f;
			m_AudioSource.UnPause();
			isOn = false;
		});
		blocker.enabled = false;
	}
}
