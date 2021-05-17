using Core.Utilities;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PopUpImage : Singleton<PopUpImage>
{
    public GameObject perfect, great, miss;

    public enum PopUpType
    {
        Perfect, Great, Miss
    }

    private GameObject m_PopUpPrefab;

    public void ShowPopUp(PopUpType type, Vector3 position, Quaternion rotation)
    {
        switch (type)
        {
            case PopUpType.Perfect:
                m_PopUpPrefab = Instantiate(perfect, position, rotation);
                break;
            case PopUpType.Great:
                m_PopUpPrefab = Instantiate(great, position, rotation);
                break;
            case PopUpType.Miss:
                m_PopUpPrefab = Instantiate(miss, position, rotation);
                break;
        }
    }
}
