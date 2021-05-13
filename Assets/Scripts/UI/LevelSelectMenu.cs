using UnityEngine;
using Core.UI;
using UnityEngine.UI;

public class LevelSelectMenu : SimpleMainMenuPage
{
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
			levelSelectButton.GetComponent<Button>().onClick.AddListener(() => LevelManager.instance.LoadScene(level.sceneName));
		}
	}
}
