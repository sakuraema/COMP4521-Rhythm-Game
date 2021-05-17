using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DebugUI : MonoBehaviour
{
	public Text perfectCount;
	public Text goodCount;
	public Text missedCount;

    // Update is called once per frame
    void Update()
    {
		perfectCount.text = LevelManager.instance.PerfectCount.ToString();
		goodCount.text = LevelManager.instance.GoodCount.ToString();
		missedCount.text = LevelManager.instance.MissedCount.ToString();
    }
}
