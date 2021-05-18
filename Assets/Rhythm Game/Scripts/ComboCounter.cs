using Core.Utilities;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class ComboCounter : Singleton<ComboCounter>
{
	private TextMeshProUGUI m_TextMesh;

	public int Combo { get; set; } = 0;

	private void Start()
    {
        gameObject.SetActive(false);
        m_TextMesh = gameObject.GetComponent<TextMeshProUGUI>();
    }

    public void IncreaseCombo()
    {
        m_TextMesh.text = (++Combo).ToString();
        if (!gameObject.activeInHierarchy)
            gameObject.SetActive(true);
    }

    public void ResetCombo()
    {
        m_TextMesh.text = (Combo = 0).ToString();
        if (gameObject.activeInHierarchy)
            gameObject.SetActive(false);
    }
}
