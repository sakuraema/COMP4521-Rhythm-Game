using Core.Utilities;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PopUpManager : Singleton<PopUpManager>
{
    public Poolable perfect, great, miss;

    public enum PopUpType
    {
        Perfect, Great, Miss
    }

    public void ShowPopUp(PopUpType type, Vector3 position, Quaternion rotation)
    {
		Poolable poolable;
        switch (type)
        {
            case PopUpType.Perfect:
				poolable = PoolManager.instance.GetPoolable(perfect);
                break;
            case PopUpType.Great:
				poolable = PoolManager.instance.GetPoolable(great);
				break;
            case PopUpType.Miss:
				poolable = PoolManager.instance.GetPoolable(miss);
                break;
			default:
				poolable = PoolManager.instance.GetPoolable(miss);
				break;
		}
		poolable.transform.position = position;
		poolable.transform.rotation = rotation;
		poolable.gameObject.SetActive(true);
		poolable.GetComponent<PopUp>().Show();
    }
}
