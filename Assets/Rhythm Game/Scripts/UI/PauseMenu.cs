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

	void Pause()
	{
		blocker.enabled = true;
		Time.timeScale = 0f;
		m_AudioSource.Pause();
		isOn = true;
	}

	void UnPause()
	{
		blocker.enabled = false;
		Time.timeScale = 1f;
		m_AudioSource.UnPause();
		isOn = false;
	}

	void BackToMainMenu()
	{
		Time.timeScale = 1f;
		isOn = false;
		StartCoroutine(LevelManager.instance.LoadSceneAsync(0));
	}

	private void Awake()
	{
		m_AudioSource = Camera.main.GetComponent<AudioSource>();
		pauseButton.onClick.AddListener(Pause);
		playButton.onClick.AddListener(UnPause);
		homeButton.onClick.AddListener(BackToMainMenu);
		blocker.enabled = false;
	}

	private void Update()
	{
		if (Input.GetKeyDown(KeyCode.Escape))
		{
			if (isOn)
			{
				UnPause();
			}
			else
			{
				Pause();
			}
		}
	}
}
