using Core.Utilities;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class ComboCounter : Singleton<ComboCounter>
{
    private int m_Combo = 0;
    private TextMeshProUGUI m_TextMesh;

    private void Start()
    {
        gameObject.SetActive(false);
        m_TextMesh = gameObject.GetComponent<TextMeshProUGUI>();
    }

    public void IncreaseCombo()
    {
        m_TextMesh.text = (++m_Combo).ToString();
        if (!gameObject.activeInHierarchy)
            gameObject.SetActive(true);
    }

    public void ResetCombo()
    {
        m_TextMesh.text = (m_Combo = 0).ToString();
        if (gameObject.activeInHierarchy)
            gameObject.SetActive(false);
    }
}
