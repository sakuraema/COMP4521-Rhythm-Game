using UnityEngine;
using Core.UI;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using System.Collections;

public class LevelSelectMenu : SimpleMainMenuPage
{
	public LevelLoadingScreen loadingScreen;
	public VerticalLayoutGroup content;
	public LevelSelectButton levelSelectButtonPrefab;

	protected override void Awake()
	{
		base.Awake();

		var levels = GameManager.instance.levelList.levels;
		foreach (var level in levels)
		{
			var levelSelectButton = Instantiate(levelSelectButtonPrefab, content.transform);
			levelSelectButton.levelName.text = level.name;
			levelSelectButton.GetComponent<Button>().onClick.AddListener(() =>
			{
				StartCoroutine(LoadSceneAsync(level.sceneName));
			});
		}
	}

	IEnumerator LoadSceneAsync(string sceneName)
	{
		AsyncOperation operation = SceneManager.LoadSceneAsync(sceneName);

		loadingScreen.gameObject.SetActive(true);
		while (!operation.isDone)
		{
			float progress = Mathf.Clamp01(operation.progress / 0.9f);

			loadingScreen.progressBar.value = progress;
			loadingScreen.percentage.text = (int)(progress * 100f) + "%";

			yield return null;
		}
	}
}
