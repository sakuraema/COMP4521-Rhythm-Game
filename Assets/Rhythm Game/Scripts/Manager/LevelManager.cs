using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using Core.Utilities;

public class LevelManager : Singleton<LevelManager>
{
	public LevelLoadingScreen loadingScreen;

	public int PerfectCount { get; set; }
	public int GoodCount { get; set; }
	public int MissedCount { get; set; }
	public int Score { get; set; }

	public void LoadScene(string sceneName)
	{
		SceneManager.LoadScene(sceneName);
	}

	public IEnumerator LoadSceneAsync(int sceneIndex)
	{
		AsyncOperation operation = SceneManager.LoadSceneAsync(sceneIndex);

		loadingScreen.GetComponent<Canvas>().enabled = true;
		while (!operation.isDone)
		{
			float progress = Mathf.Clamp01(operation.progress / 0.9f);

			loadingScreen.progressBar.value = progress;
			loadingScreen.percentage.text = (int)(progress * 100f) + "%";

			yield return null;
		}
	}

	public IEnumerator LoadSceneAsync(string sceneName)
	{
		AsyncOperation operation = SceneManager.LoadSceneAsync(sceneName);

		loadingScreen.GetComponent<Canvas>().enabled = true;
		while (!operation.isDone)
		{
			float progress = Mathf.Clamp01(operation.progress / 0.9f);

			loadingScreen.progressBar.value = progress;
			loadingScreen.percentage.text = (int)(progress * 100f) + "%";

			yield return null;
		}
	}
}
