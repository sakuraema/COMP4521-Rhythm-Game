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
		perfectCount.text = ScoreManager.instance.perfectCount.ToString();
		goodCount.text = ScoreManager.instance.goodCount.ToString();
		missedCount.text = ScoreManager.instance.missedCount.ToString();
    }
}
