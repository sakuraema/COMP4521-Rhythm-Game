using UnityEngine;
using Core.UI;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System.Collections;

public class LevelSelectMenu : SimpleMainMenuPage
{
	public VerticalLayoutGroup content;
	public LevelSelectButton levelSelectButtonPrefab;
	public Image background;

	private string m_SelectedSceneName = "";
	private AudioSource m_AudioPlayer;
	private AudioClip m_OriginalClip;

	public override void Hide()
	{
		base.Hide();

		m_AudioPlayer.Stop();
		m_AudioPlayer.clip = m_OriginalClip;
		m_AudioPlayer.Play();
		m_SelectedSceneName = "";

		StartCoroutine(FadeOut());
		background.sprite = null;
	}

	private IEnumerator FadeOut()
	{
		for (float ft = 1f; ft >= 0; ft -= Time.deltaTime)
		{
			Color c = background.color;
			c.a = ft;
			background.color = c;
			yield return null;
		}
	}

	private IEnumerator FadeIn()
	{
		for (float ft = 0f; ft < 1f; ft += Time.deltaTime)
		{
			Color c = background.color;
			c.a = ft;
			background.color = c;
			yield return null;
		}
	}

	protected override void Awake()
	{
		base.Awake();

		m_AudioPlayer = Camera.main.GetComponent<AudioSource>();
		m_OriginalClip = m_AudioPlayer.clip;

		var levels = GameManager.instance.levelList.levels;
		foreach (var level in levels)
		{
			var levelSelectButton = Instantiate(levelSelectButtonPrefab, content.transform);
			levelSelectButton.levelName.text = level.name;
			levelSelectButton.GetComponent<Button>().onClick.AddListener(() =>
			{
				if (m_SelectedSceneName.Equals(level.sceneName))
				{
					StartCoroutine(LevelManager.instance.LoadSceneAsync(level.sceneName));
				}
				else
				{
					m_SelectedSceneName = level.sceneName;
					background.sprite = level.previewImage;
					StartCoroutine(FadeIn());
					m_AudioPlayer.Stop();
					m_AudioPlayer.clip = level.previewClip;
					m_AudioPlayer.Play();
				}
			});
		}
	}
}
